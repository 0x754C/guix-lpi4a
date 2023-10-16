#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <limits.h>
#include <fcntl.h>
#include <linux/i2c-dev.h>
#include <linux/uinput.h>

int uinput_fd;

ssize_t eread(int fd, void *buf, size_t count)
{
	ssize_t nr;
	while ((nr = read(fd, buf, count)) < 0) {
		if (errno == EINTR) {
			continue;
		} else {
			perror("read failed");
			break;
		}
	}
	return nr;
}

ssize_t ewrite(int fd, void *buf, size_t count)
{
	ssize_t nw;
	while ((nw = write(fd, buf, count)) < 0) {
		if (errno == EINTR) {
			continue;
		} else {
			perror("write failed");
			break;
		}
	}
	return nw;
}

void emit(int uinput_fd, int type, int code, int val)
{
	struct input_event ie;

	ie.type = type;
	ie.code = code;
	ie.value = val;
	ie.input_event_sec = 0;
	ie.input_event_usec = 0;

	ewrite(uinput_fd, &ie, sizeof(ie));
}

int main(int argc, char *argv[])
{
	int i2c_bus = 0;
	int i2c_addr = 0x15;
	int gpio_num = 512;
	int i;
	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "-y") == 0) {
			i++;
			i2c_bus = atoi(argv[i]);
		} else if (strcmp(argv[i], "-a") == 0) {
			i++;
			i2c_addr = strtol(argv[i], NULL, 16);
		} else if (strcmp(argv[i], "-i") == 0) {
			i++;
			gpio_num = atoi(argv[i]);
		} else if (strcmp(argv[i], "-h") == 0) {
			fprintf(stderr, "usage: %s [options]\n", argv[0]);
			fprintf(stderr, " -y BUS      set i2c bus\n");
			fprintf(stderr, " -a ADDR     set i2c address\n");
			fprintf(stderr, " -i GPIO_NUM set gpio use for interrupt\n");
			fprintf(stderr, " -h          print help\n");
			exit(EXIT_FAILURE);
		}
	}

	char i2c_fn[PATH_MAX];
	snprintf(i2c_fn, PATH_MAX - 1, "/dev/i2c-%d", i2c_bus);
	int i2c_fd = -1;
	while (i2c_fd < 0) {
		i2c_fd = open(i2c_fn, O_RDWR);
		if (i2c_fd < 0) {
			printf("wait i2cbus\n\r");
		}
	}

	uinput_fd = open("/dev/uinput", O_WRONLY | O_NONBLOCK);
	if (uinput_fd < 0) {
		perror("open /dev/uinput failed");
		exit(EXIT_FAILURE);
	}

	ioctl(uinput_fd, UI_SET_EVBIT, EV_KEY);
	ioctl(uinput_fd, UI_SET_KEYBIT, BTN_LEFT);
	ioctl(uinput_fd, UI_SET_KEYBIT, BTN_RIGHT);
	ioctl(uinput_fd, UI_SET_EVBIT, EV_REL);
	ioctl(uinput_fd, UI_SET_RELBIT, REL_X);
	ioctl(uinput_fd, UI_SET_RELBIT, REL_Y);
	ioctl(uinput_fd, UI_SET_RELBIT, REL_WHEEL);
	struct uinput_setup usetup;
	memset(&usetup, 0, sizeof(usetup));
	usetup.id.bustype = BUS_I2C;
	strcpy(usetup.name, "ydx");
	ioctl(uinput_fd, UI_DEV_SETUP, &usetup);
	ioctl(uinput_fd, UI_DEV_CREATE);

	if (ioctl(i2c_fd, I2C_SLAVE, i2c_addr) < 0) {
		perror("can't set i2c slave address");
		exit(EXIT_FAILURE);
	}

	uint8_t buf[BUFSIZ];

	/*
	int gpio_fd;
	char gpio_fn[PATH_MAX];
	snprintf(gpio_fn, PATH_MAX, "/sys/class/gpio/gpio%d", gpio_num);
	if (access(gpio_fn, F_OK) < 0) {
		snprintf(gpio_fn, PATH_MAX, "/sys/class/gpio/export");
		gpio_fd = open(gpio_fn, O_WRONLY);
		if (gpio_fd < 0) {
			perror("open");
			exit(EXIT_FAILURE);
		}
		snprintf(buf, BUFSIZ, "%d", gpio_num);
		if (ewrite(gpio_fd,buf, strlen(buf)) < 0) {
			perror("write failed");
			exit(EXIT_FAILURE);
		}
		close(gpio_fd);
	}
	snprintf(gpio_fn, PATH_MAX, "/sys/class/gpio/gpio%d/direction", gpio_num);
	gpio_fd = open(gpio_fn, O_WRONLY);
	if (gpio_fd < 0) {
		perror("open");
		exit(EXIT_FAILURE);
	}
	snprintf(buf, BUFSIZ, "in");
	if (ewrite(gpio_fd, buf, strlen(buf)) < 0) {
		perror("write");
		exit(EXIT_FAILURE);
	}
	close(gpio_fd);
	snprintf(gpio_fn, PATH_MAX, "/sys/class/gpio/gpio%d/value", gpio_num);
	gpio_fd = open(gpio_fn, O_RDONLY);
	if (gpio_fd < 0) {
		perror("open");
		exit(EXIT_FAILURE);
	}
	*/

	buf[0] = 0x20;
	buf[1] = 0x00;
	ewrite(i2c_fd, buf, 2);

	int8_t x, y;
	int xs, ys;

	while (1) {
		usleep(10000);
		eread(i2c_fd, buf, 7);
		if (buf[0] == 0x07) {
			if ((buf[4] != 0) || (buf[5] != 0)) {
				x = abs((int8_t)buf[4]);
				if (abs((int8_t)buf[4]) > 5) {
					x = x >> 1;
				}
				y = abs((int8_t)buf[5]);
				if (abs((int8_t)buf[5]) > 5) {
					y = y >> 1;
				}
				if (buf[4] & (1 << 7)) {
					xs = 1;
				} else {
					xs = 0;
				}
				for (i = 0; i < x; i++) {
					emit(uinput_fd, EV_REL, REL_X, (xs == 1 ? -1 : 1));
				}
				if (buf[5] & (1 << 7)) {
					ys = 1;
				} else {
					ys = 0;
				}
				for (i = 0; i < y; i++) {
					emit(uinput_fd, EV_REL, REL_Y, (ys == 1 ? -1 : 1));
				}
				//emit(uinput_fd, EV_REL, REL_X, x);
				//emit(uinput_fd, EV_REL, REL_Y, y);
				printf("%d %d\n", x, y);
			}
		}
	}

	exit(EXIT_SUCCESS);
}
