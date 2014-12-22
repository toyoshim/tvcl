TESTS	= LED Parity Arbitor Multiplexer SerialReceiver SerialTransmitter RAM
RESULTS	= $(addsuffix .result, $(TESTS))

all: check

clean:
	rm -rf *.result *.diff *.vcd iver

run: $(RESULTS)

check: run
	@for test in $(TESTS); do \
		diff $$test.result $$test.expected > $$test.diff; \
		if [ $$? -eq 0 ]; then \
			echo "[ PASS ] $$test"; \
		else \
			echo "[ FAIL ] $$test"; \
			cat $$test.diff; \
		fi \
	done

%result:
	iverilog -o iver $^ && ./iver > $@

LED.result: LED.v ../sample/LED.v ../SevenSegmentLED.v
Parity.result: Parity.v ../EvenParityGenerator.v ../EvenParityChecker.v \
		../OddParityGenerator.v ../OddParityChecker.v
Arbitor.result: Arbitor.v ../FixedPriorityArbitor.v
Multiplexer.result: Multiplexer.v ../Multiplexer4.v
SerialReceiver.result: SerialReceiver.v ../SerialReceiver.v
SerialTransmitter.result: SerialTransmitter.v ../SerialTransmitter.v \
		../SerialReceiver.v
RAM.result: RAM.v ../ram/simulation/RAM.v ../ram/simulation/RAM_64Kx8.v
