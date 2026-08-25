use strict;
use warnings;

use Config;
use File::Path qw(make_path);
use File::Spec;
use File::Temp qw(tempdir);

my ($lcov_lib, $genhtml) = @ARGV;
die "usage: $0 LCOV_LIB GENHTML\n" unless defined($genhtml);

unshift(@INC, $lcov_lib);
require lcovutil;

my %dates = (
    '2024-01-02T03:04:05Z'      => 1704164645,
    '2024-01-02T05:34:05+02:30' => 1704164645,
    '2024-01-01T23:04:05-04:00' => 1704164645,
);

for my $date (sort(keys(%dates))) {
    my $actual = lcovutil::parse_w3cdtf($date);
    die "parse_w3cdtf($date) returned $actual, expected $dates{$date}\n"
        unless $actual == $dates{$date};
}

# Exercise --baseline-date while making Date::Parse deliberately unavailable.
# genhtml must fall back to the baseline trace file's modification time.
my $tmpdir = tempdir(CLEANUP => 1);
my $source = File::Spec->catfile($tmpdir, 'source.c');
my $base   = File::Spec->catfile($tmpdir, 'base.info');
my $trace  = File::Spec->catfile($tmpdir, 'trace.info');
my $output = File::Spec->catdir($tmpdir, 'html');
my $block  = File::Spec->catdir($tmpdir, 'blocked-modules');
make_path(File::Spec->catdir($block, 'Date'));

write_file($source, "int main(void) { return 0; }\n");
write_trace($base, $source, 0);
write_trace($trace, $source, 1);
write_file(
    File::Spec->catfile($block, 'Date', 'Parse.pm'),
    "die qq(Date::Parse intentionally unavailable for package test\\n);\n",
);

local $ENV{PERL5LIB} = join($Config::Config{path_sep}, $block, $lcov_lib);
my $status = system(
    $genhtml,
    '--baseline-file', $base,
    '--baseline-date', '2024-01-02T03:04:05Z',
    '--output-directory', $output,
    '--no-sourceview',
    $trace,
);
die "genhtml --baseline-date failed with status $status\n" unless $status == 0;
die "genhtml did not produce index.html\n"
    unless -f File::Spec->catfile($output, 'index.html');
my $index = read_file(File::Spec->catfile($output, 'index.html'));
die "genhtml output did not retain the requested baseline date\n"
    unless $index =~ /2024-01-02T03:04:05Z/;

sub write_trace
{
    my ($path, $source_path, $count) = @_;
    write_file($path, "TN:\nSF:$source_path\nDA:1,$count\nend_of_record\n");
}

sub write_file
{
    my ($path, $contents) = @_;
    open(my $handle, '>', $path) or die "cannot write $path: $!\n";
    print({$handle} $contents) or die "cannot write $path: $!\n";
    close($handle) or die "cannot close $path: $!\n";
}

sub read_file
{
    my ($path) = @_;
    open(my $handle, '<', $path) or die "cannot read $path: $!\n";
    local $/;
    my $contents = <$handle>;
    close($handle) or die "cannot close $path: $!\n";
    return $contents;
}
