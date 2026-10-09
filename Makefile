SRC_DIR := ./src_dir
MALICIOUS_DIR := ./malicious_dir
DELAY := 5

.PHONY: all antivirus restore clean

all: antivirus

$(MALICIOUS_DIR):
	mkdir -p $(MALICIOUS_DIR)

antivirus: $(MALICIOUS_DIR)
	./antivirusd.sh $(SRC_DIR) $(MALICIOUS_DIR) $(DELAY)

restore: $(MALICIOUS_DIR)
	./restore.sh $(SRC_DIR) $(MALICIOUS_DIR)

clean:
	rm -f directory-info.last directory-info.new whitelist.txt