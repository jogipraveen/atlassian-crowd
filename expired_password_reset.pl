#Script used to send an email to users whose password expired in Atlassian crowd
#!/usr/bin/perl
use strict;
use DBI;
use DBD::mysql;
use vars qw( @row @list $uname $platform $database $user $pw $dsn $connect $sql $sth $email $dbh );
$platform = "mysql";
$database = "crowd";
$user = "crowduser";
$pw = "crowduser";
$dsn = "dbi:$platform:$database:localhost:3306";
$connect = DBI->connect($dsn, $user, $pw) or die "Connection Error: $DBI::errstr\n";
$sql = "select email_address from cwd_user_attribute a, cwd_user u where u.id=a.user_id and a.attribute_name='requiresPasswordChange' and a.attribute_value='true' and u.active = 'T'";
$sth = $connect->prepare($sql);
$sth->execute() or die $dbh->errstr;
while (@row = $sth->fetchrow_array)
{
    foreach my $n (@row)
    {
        chomp $n;
        @list = split(/\@/,$n);
	$uname = $list[0];
	system("echo -e Hi $uname,;echo 'Your account password expired.' | mail -s 'Your password expired' -r admin\@admin.com $n");
    }
}
