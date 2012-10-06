HOME=/Users/colomon
RAKUDO=$(HOME)/tools/rakudo/perl6
NIECZA=mono $(HOME)/tools/niecza/run/Niecza.exe

test: rakudo-test niecza-test

rakudo-test:
	prove -e "$(RAKUDO) -Ilib" --verbose t/

niecza-test:
	prove -e "$(NIECZA) -Ilib" --verbose t/

