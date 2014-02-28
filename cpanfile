requires "Config::Tiny" => "0";
requires "Dancer" => "0";
requires "Data::Dumper" => "0";
requires "Date::Manip::Date" => "0";
requires "Devel::Pragma" => "0.60";
requires "Exobrain" => "0";
requires "Exobrain::Bus" => "0";
requires "Exobrain::Cache" => "0";
requires "Exobrain::Config" => "0";
requires "Exobrain::Intent::HabitRPG" => "0";
requires "Exobrain::Message" => "0";
requires "Exobrain::Router" => "0";
requires "Getopt::Std" => "0";
requires "IO::Socket::SSL" => "0";
requires "JSON::Any" => "0";
requires "Method::Signatures" => "0";
requires "Net::IMAP::Client" => "0";
requires "POSIX" => "0";
requires "SMS::Send" => "0";
requires "Socket" => "0";
requires "Term::ReadKey" => "0";
requires "Try::Tiny" => "0";
requires "Ubic" => "0";
requires "Ubic::Multiservice::Simple" => "0";
requires "Ubic::Service::SimpleDaemon" => "0";
requires "WWW::Mechanize" => "0";
requires "WebService::Beeminder" => "0";
requires "WebService::HabitRPG" => "0";
requires "WebService::Idonethis" => "0.22";
requires "WebService::Pushover" => "0";
requires "WebService::RTMAgent" => "0.600";
requires "autodie" => "0";
requires "constant" => "0";
requires "perl" => "5.010";
requires "strict" => "0";
requires "utf8::all" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "Exobrain::Agent" => "0";
  requires "Exobrain::Measurement::Mailbox" => "0";
  requires "Exobrain::Message::Raw" => "0";
  requires "Exobrain::Test" => "0";
  requires "File::Spec" => "0";
  requires "FindBin" => "0";
  requires "Moose" => "0";
  requires "Test::More" => "0";
  requires "Test::Most" => "0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.30";
};

on 'develop' => sub {
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";
};
