#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <linux/hidraw.h>

int main(int argc, char *argv[]) {
	struct rawhid_struct *hid;
	struct stat devstat;
	struct hidraw_devinfo info;
	struct hidraw_report_descriptor *desc;
	char buf[512];
	int r, i, fd=-1, len, found=0;

	printf("Searching for device using hidraw....\n");
	for (i=0; i<HIDRAW_MAX_DEVICES; i++) {
		if (fd > 0)
			close(fd);
			
		snprintf(buf, sizeof(buf), "/dev/hidraw%d", i);
		r = stat(buf, &devstat);
		if (r < 0)
			continue;
		
		printf("device: %s\n", buf);
		fd = open(buf, O_RDWR);
		if (fd < 0)
			continue;
		
		printf("  opened\n");
		r = ioctl(fd, HIDIOCGRAWINFO, &info);
		if (r < 0)
			continue;
		
		printf("  vid=%04X, pid=%04X\n", info.vendor & 0xFFFF, info.product & 0xFFFF);
	}

	return 0;
}
