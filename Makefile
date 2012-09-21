test: rakudo-test niecza-test

rakudo-test:
	prove -e "/home/colomon/tools/rakudo/perl6 -Ilib" --verbose t/

niecza-test:
	prove -e "mono /home/colomon/tools/niecza/run/Niecza.exe -Ilib" --verbose t/

