EXE=timepng

all: $(EXE)

timepng: timepng.c
	$(CC) -W -Wall -o $@ $< -lpng -lz -lm

.PHONY: clean

clean:
	rm -f $(EXE)
