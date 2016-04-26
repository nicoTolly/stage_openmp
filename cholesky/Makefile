DEPDIR := .d
$(shell mkdir -p $(DEPDIR) >/dev/null)
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Td


CC=gcc
CFLAGS=-Wall -fopenmp 
LFLAGS= -lm
BIN_DIR= bin
EXEC=$(BIN_DIR)/cholesky-for $(BIN_DIR)/cholesky-dep $(BIN_DIR)/basic-cholesky
SOURCES= $(wildcard *.c)
OBJECTS=$(patsubst %.c, $(BIN_DIR)/%.o, $(SOURCES))

POSTCOMPILE = mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d

.PHONY: all clean mrproper

all : $(EXEC)


$(BIN_DIR)/cholesky-for : $(BIN_DIR)/main.o $(BIN_DIR)/mytimer.o $(BIN_DIR)/hilbert-mat.o $(BIN_DIR)/cholesky-for.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/cholesky-for $^ $(LFLAGS)

$(BIN_DIR)/cholesky-dep : $(BIN_DIR)/main.o $(BIN_DIR)/mytimer.o $(BIN_DIR)/hilbert-mat.o $(BIN_DIR)/cholesky-dep.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/cholesky-dep $^ $(LFLAGS)

$(BIN_DIR)/basic-cholesky : $(BIN_DIR)/main.o $(BIN_DIR)/mytimer.o $(BIN_DIR)/hilbert-mat.o $(BIN_DIR)/basic-cholesky.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/basic-cholesky $^ $(LFLAGS)

$(OBJECTS): $(BIN_DIR)/%.o : %.c 
$(BIN_DIR)/%.o : %.c $(DEPDIR)/%.d
	$(CC) $(CFLAGS) $(DEPFLAGS) -o $@ -c $< 
	$(POSTCOMPILE)


$(DEPDIR)/%.d: ;
.PRECIOUS: $(DEPDIR)/%.d

-include $(patsubst %,$(DEPDIR)/%.d,$(basename $(SOURCES)))

clean:
	rm -fr $(BIN_DIR)/*.o

mrproper:
	rm -fr $(BIN_DIR)/*.o $(EXEC)

