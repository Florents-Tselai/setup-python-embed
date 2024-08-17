
PYTHON ?=
PYVERSION = $(shell $(PYTHON) -c "import sysconfig; print(sysconfig.get_config_var('VERSION'))")
PYTHON_CONFIG = $(PYTHON)-config

embed: embed.c
	gcc -o $@ $< $(shell $(PYTHON_CONFIG) --cflags --ldflags) -lpython$(PYVERSION)

all: embed

clean:
	-rm embed

test: embed
	@output=$$(./embed); if [ "$$output" = "$(PYVERSION)" ]; then \
		echo "Test passed! Output: $$output"; \
	else \
		echo "Test failed! Expected: $(PYVERSION), but got: $$output"; \
		exit 1; \
	fi