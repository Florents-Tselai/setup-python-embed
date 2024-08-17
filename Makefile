
PG_CONFIG ?= pg_config

EXTVERSION = 0.1.0

EXTENSION = pgpyembed
MODULE_big = $(EXTENSION)
OBJS = $(EXTENSION).o

DATA = $(wildcard sql/*--*.sql)

TESTS = $(wildcard test/sql/*.sql)
REGRESS = $(patsubst test/sql/%.sql,%,$(TESTS))
REGRESS_OPTS = --inputdir=test --load-extension=$(EXTENSION)

PYTHON ?= python3.11
PYVERSION ?= 3.11
PYTHON_CONFIG = $(PYTHON)-config

CC ?=
PG_CFLAGS ?= $(shell $(PYTHON)-config --includes)
PG_LDFLAGS ?=
SHLIB_LINK += -lpython$(PYVERSION)



#embed: embed.c
#	gcc -o $@ $< $(shell $(PYTHON_CONFIG) --cflags --ldflags) -lpython$(PYVERSION)

test-python-embedding: embed
	@output=$$(./embed); if [ "$$output" = "$(PYVERSION)" ]; then \
		echo "Test passed! Output: $$output"; \
	else \
		echo "Test failed! Expected: $(PYVERSION), but got: $$output"; \
		exit 1; \
	fi


EXTRA_CLEAN: embed

PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)