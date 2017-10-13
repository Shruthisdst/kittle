#!/usr/bin/perl

open(IN, "kittel.tex") or die "Can't open kittel.txt";
open(OUT, ">kittel.html") or die "Can't open kittel.html";

$line = <IN>;
$count = 1;

$preamble = "<!doctype html>
<html lang=\"en\" class=\"no-js\">
<head>
	<meta charset=\"UTF-8\">
	<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
</head>
<body>";

$post = "</body>
</html>";

print OUT $preamble . "\n";
print OUT "<div class=\"container\">" . "\n";

while($line)
{
	chop($line);
	if($line =~ /\\begin{entry}/)
	{
		print OUT "\t<div class=\"snippet\" id=\"$count\">" . "\n";
		$count++;
	}
	elsif($line =~ /\\word{(.*)}/)
	{
		$word = $1;
		$word = gen_unicode($word);
		$word = replace_accented($word);
		print OUT "\t\t<div class=\"word\">$word" . "<\/div>\n";
	}
	elsif($line =~ /\\enword{(.*)}/)
	{
		$enword = $1;
		$enword =~ s/\{\\rm (.*?)\}/\1/g;
		$enword =~ s/\\emph\{(.*?)\}/<i>\1<\/i>/;
		$enword = replace_accented($enword);
		print OUT "\t\t<div class=\"enword\">$enword<\/div>" . "\n";
	}
	elsif($line =~ /\\meaning{(.*)}/)
	{
		$mng = $1;
		$unicode_mng = replace_accented($mng);
		$unicode_mng1 = gen_unicode($unicode_mng);
		print OUT "\t\t<p class=\"mng\">$unicode_mng1<\/p>" . "\n";
	}
	elsif($line =~ /\\gade{(.*)}/)
	{
		$gade = $1;
		$gade = gen_unicode($gade);
		$gade = replace_accented($gade);
		print OUT "\t\t<p class=\"gade\">$gade<\/p>" . "\n";
	}
	elsif($line =~ /\\usage{(.*)}/)
	{
		$usage = $1;
		$usage = gen_unicode($usage);
		$usage = replace_accented($usage);
		print OUT "\t\t<p class=\"usage\">$usage<\/p>" . "\n";
	}
	elsif($line =~ /\\equal{(.*)}/)
	{
		$equal = $1;
		$equal = gen_unicode($equal);
		$equal = replace_accented($equal);
		print OUT "\t\t<p class=\"equal\">$equal<\/p>" . "\n";
	}
	elsif($line =~ /\\end{entry}/)
	{
		print OUT "\t<\/div>" . "\n";
	}
	else
	{
		print OUT gen_unicode($line) . "\n";
	}
	$line = <IN>;
}
print OUT "<\/div>" . "\n";

print OUT $post . "\n";

close(IN);
close(OUT);

print $count . "\n";

sub gen_unicode()
{
	my($kan_str) = @_;
	open(TMP, ">tmp.txt") or die "Can't open tmp.txt\n";
	my ($tmp,$flg,$i,$endash_uni,$endash,$flag);
	$flg = 1;

	$kan_str =~ s/\\ralign\{(.*?)\}/!E! $ralign_btag !K! $1 !E! $ralign_etag !K! /g;
	#~ $kan_str =~ s/\\char'263/!E!&#x0CBD;!K!/g;
	$kan_str =~ s/\\char'263/!E!&#x93d;!K!/g;
	$kan_str =~ s/\\char'365/!E!&#x0CC4;!K!/g;
	$kan_str =~ s/\\char'273/!E!&#x0CB1;!K!/g;
	$kan_str =~ s/\\char'366/nf/g;
	$kan_str =~ s/\\char'361/nf/g;
	$kan_str =~ s/\\s /!E!&#x0CBD;!K!/g;
	$kan_str =~ s/\\s/!E!&#x0CBD;!K!/g;
	$kan_str =~ s/\\S /!E!&#x0CBD;!K!/g;
	$kan_str =~ s/\\S/!E!&#x0CBD;!K!/g;
	$kan_str =~ s/\\cdots/!E!&#x2026;!K!/g;
	$kan_str =~ s/&#x2014;/!E!&#x2014;!K!/g;
	$kan_str =~ s/&#8212;/ !E!&#x2014;!K! /g;
	$kan_str =~ s/\$\}/\$!K!/g;
	$kan_str =~ s/\\char'220/sx/g;
	$kan_str =~ s/\\%/%/g;
	$kan_str =~ s/\\char36/!E!\$\\\$\$!K!/g;
	$kan_str =~ s/\\ae/!E!&#x00E6;!K!/g;
	$kan_str =~ s/\\char143\\ /Px/g;
	$kan_str =~ s/\\char143/Px/g;
	$kan_str =~ s/\\char144\\ /sx/g;
	$kan_str =~ s/\\char144/sx/g;
	$kan_str =~ s/eZ\\char'261/oZ/g;
	$kan_str =~ s/ez\\char'261V/oVz/g;
	$kan_str =~ s/sz\\char'301/sAz/g;
	$kan_str =~ s/\\char168\\char177/yiV/g;
	$kan_str =~ s/\\pounds/!E!&#163;!K!/g;
	$kan_str =~ s/\\&/!E!&amp;!K!/g;
	$kan_str =~ s/\\bf//g;
	#~ $kan_str =~ s/\\&/&amp;/g;
	$kan_str =~ s/\{\\yoghsymb\\char178\}/!E!&#x021D;!K!/g;
	#$kan_str =~ s/\\num\{(.*?)\}//g;
	$kan_str =~ s/\\ralign\{(.*?)\}/!E! $ralign_btag !K! $1 !E! $ralign_etag !K! /g;
	$kan_str =~ s/\\char'263/!E!&#x0CBD;!K!/g;
	$kan_str =~ s/\\char'365/!E!&#x0CC4;!K!/g;
	$kan_str =~ s/\\char'273/!E!&#x0CB1;!K!/g;
	$kan_str =~ s/\\copyright/!E!&#x00A9;!K!/g;
	$kan_str =~ s/\\s /!E!&#x0CBD;!K!/g;

	$flag = 1;
	while($flag)
	{
		#print "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH\n";
		if($kan_str =~ /\\src\{\\emph\{\\(.*?)\}\}/)
		{
			$kan_str =~ s/\\src\{\\emph\{\\(.*?)\}\}/!E!<i>\1<\/i>!K!/;
		}
		elsif($kan_str =~ /\\src\{\\emph\{(.*?)\}\}/)
		{
			$kan_str =~ s/\\src\{\\emph\{(.*?)\}\}/!E!<i>\1<\/i>!K!/;
		}
		elsif($kan_str =~ /\\emph\{\\(.*?)\}/)
		{
			$kan_str =~ s/\\emph\{\\(.*?)\}/!E!<i>\1<\/i>!K!/;
		}
		elsif($kan_str =~ /\\emph\{(.*?)\}/)
		{
			$kan_str =~ s/\\emph\{(.*?)\}/!E!<i>\1<\/i>!K!/;
		}
		elsif($kan_str =~ /\\textit\{(.*?)\}/)
		{
			$kan_str =~ s/\\textit\{(.*?)\}/!E!<i>\1<\/i>!K!/;
		}
		elsif($kan_str =~ /\\see\{(.*?)\}/)
		{
			$kan_str =~ s/\\see\{(.*?)\}/!E!<see>\1<\/see>!K!/;
		}
		elsif($kan_str =~ /\\src\{(.*?)\}/)
		{
			$kan_str =~ s/\\src\{(.*?)\}/<span>\1<\/span>/;
		}
		elsif($kan_str =~ /\$(.*?)\$/)
		{
			$kan_str =~ s/\$(.*?)\$/!E! \1 !K!/;
			$kan_str =~ s/\^\\circ/&#xB0;/g;
		}
		elsif($kan_str =~ /\\gade{(.*)}/)
		{
			$kan_str =~ s/\\gade{(.*)}/!E!<p class=\"gade\">!K!\1!E!<\/p>!K!/;
		}
		elsif($kan_str =~ /\\rmi\{(.*?)\}/)
		{
			$kan_str =~ s/\\rmi\{(.*?)\}/!E!<i>\1<\/i>!K!/;
		}
		elsif($kan_str =~ /\{\\rm (.*?)\}/)
		{
			$kan_str =~ s/\{\\rm (.*?)\}/!E!\1!K!/;
		}
		
		else
		{
			$flag = 0;
		}
	}
	$kan_str =~ s/\{//g;
	$kan_str =~ s/\}//g;
	
	#print $kan_str . "\n";
	
	#$endash = "&#x2014";
	#$endash_uni = chr(hex($endash));
	
	print TMP $kan_str;
	close(TMP);
	
	system("./to_unicode4 tmp.txt > tmp1.txt");
	open(UN, "tmp1.txt") or die "Can't open tmp1.txt\n";
	my $uni_str = <UN>;
	close(UN);
	
	#print FOUT $uni_str . "\n";
	
	my($decval,$val,$p);
	$uni_str =~ s/<br>//g;
	$uni_str =~ s/<\/br>//g;
	$uni_str =~ s/---/&#x2014;/g;
	$uni_str =~ s/--/&#x2013;/g;
	$uni_str =~ s/\|/&#x007C;/g;
	$uni_str =~ s/``/&#x201C;/g;
	$uni_str =~ s/''/&#x201D;/g;
	$uni_str =~ s/`/&#x2018;/g;
	$uni_str =~ s/'/&#x2019;/g;
	$uni_str =~ s/&nbsp;/&#xa0;/g;
	$uni_str =~ s/\\\~{n}/&#xF1;/g;
	#$uni_str =~ s/(&#x0CCD;)(&#x200C;)(&#x0C97;)(&#x0CCD;)/\1\3\4/;

	while($flg)
	{
		if($uni_str =~ /&#x([0-9A-F]+);/)
		{
			$val = $1;
			$p = chr(hex($val));
			$uni_str =~ s/&#x$val;/$p/g;
		}
		else
		{
			$flg = 0;
		}
	}

	#$uni_str =~ s/\bಸರ್‍\b/ಸರ್/g;
	return $uni_str;
}

sub replace_accented()
{
	my($accented_str) = @_;
	
	$accented_str =~ s/\\\^{a}/â/g;
	$accented_str =~ s/\\\={a}/ā/g;
	$accented_str =~ s/\\\={o}/ō/g;
	$accented_str =~ s/\\\={i}/ī/g;
	$accented_str =~ s/\\\={e}/ē/g;
	$accented_str =~ s/\\\={u}/ū/g;
	$accented_str =~ s/\\\^{i}/î/g;
	$accented_str =~ s/\\d{a}/ạ/g;
	$accented_str =~ s/\\d{b}/ḅ/g;
	$accented_str =~ s/\\d{d}/ḍ/g;
	$accented_str =~ s/\\d{e}/ẹ/g;
	$accented_str =~ s/\\d{h}/ḥ/g;
	$accented_str =~ s/\\d{k}/ḳ/g;
	$accented_str =~ s/\\d{l}/ḷ/g;
	$accented_str =~ s/\\d{m}/ṃ/g;
	$accented_str =~ s/\\\.{n}/ṇ/g;
	$accented_str =~ s/\\d{n}/ṇ/g;
	$accented_str =~ s/\\d{o}/ọ/g;
	$accented_str =~ s/\\d{r}/ṛ/g;
	$accented_str =~ s/\\d{s}/ṣ/g;
	$accented_str =~ s/\\d{t}/ṭ/g;
	$accented_str =~ s/\\d{u}/ụ/g;
	$accented_str =~ s/\\d{v}/ṿ/g;
	$accented_str =~ s/\\d{w}/ẉ/g;
	$accented_str =~ s/\\d{y}/ỵ/g;
	$accented_str =~ s/\\d{z}/ẓ/g;
	$accented_str =~ s/\\\~{n}/ñ/g;
	$accented_str =~ s/\\\.{m}/ṁ/g;
	$accented_str =~ s/\\v{s}/ś/g;
	$accented_str =~ s/\\'{s}/ś/g;
	
	return $accented_str;

}
