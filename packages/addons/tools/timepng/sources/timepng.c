#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <sys/time.h>

#include <png.h>

unsigned long long get_timestamp()
{
	struct timeval tv;
	gettimeofday(&tv, NULL);
	return 1000000 * (unsigned long long)tv.tv_sec + tv.tv_usec;
}

int read_png(const char* filename)
{
	png_image image;
	png_bytep buffer;
	int ret = 0;

	memset(&image, 0, sizeof image);
	image.version = PNG_IMAGE_VERSION;

	if (!png_image_begin_read_from_file(&image, filename))
		goto out;

	image.format = PNG_FORMAT_RGBA;

	buffer = malloc(PNG_IMAGE_SIZE(image));
	if (buffer == NULL)
		goto out_free_image;

	ret = png_image_finish_read(&image, NULL/*background*/, buffer,
		0/*row_stride*/, NULL/*colormap for PNG_FORMAT_FLAG_COLORMAP */);

	free(buffer);

out_free_image:
	png_image_free(&image);

out:
	return ret;
}

int main(int argc, const char **argv)
{
	int idx = 1;
	int ok;
	unsigned long long ts_start, ts_end;

	for (idx = 1; idx < argc; idx++) {
		const char* filename = argv[idx];

		ts_start = get_timestamp();
		ok = read_png(filename);
		ts_end = get_timestamp();

		if (ok) {
			printf("%10llu %s\n", ts_end - ts_start, filename);
		} else {
			fprintf(stderr, "error reading %s\n", filename);
		}
	}

	return 0;
}
