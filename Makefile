
PYTHON ?=
PYVERSION ?=
PYTHON_CONFIG = $(PYTHON)-config

embed: embed.c
	gcc -o $@ $< $(shell $(PYTHON_CONFIG) --cflags --ldflags) -lpython$(PYVERSION)

test-python-embedding: embed
	@output=$$(./embed); if [ "$$output" = "$(PYVERSION)" ]; then \
		echo "Test passed! Output: $$output"; \
	else \
		echo "Test failed! Expected: $(PYVERSION), but got: $$output"; \
		exit 1; \
	fi

PG_CONFIG ?= pg_config

EXTVERSION = 0.1.0

MODULE_big = pgpyembed
OBJS = pgpyembed.o
EXTENSION = pgpyembed

DATA = $(wildcard sql/*--*.sql)

TESTS = $(wildcard test/sql/*.sql)
REGRESS = $(patsubst test/sql/%.sql,%,$(TESTS))
REGRESS_OPTS = --inputdir=test --load-extension=$(EXTENSION)

CC ?=
PG_CFLAGS ?=
PG_LDFLAGS ?=
SHLIB_LINK = -lpython$(PYVERSION)

EXTRA_CLEAN: embed

PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)