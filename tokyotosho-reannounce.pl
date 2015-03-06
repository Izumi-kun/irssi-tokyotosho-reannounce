use strict;
use vars qw($VERSION %IRSSI);
use Irssi;

$VERSION = '1.00';
%IRSSI = (
    authors     => 'Izumi-kun',
    contact     => 'izumi-kun@ruanime.org',
    name        => 'TokyoTosho-reannounce',
    description => 'Reannounce releases from TokyoTosho into your channel',
    license     => 'Public Domain',
);

#todo: to irssi settings
my $toshobot = 'TokyoTosho';
my $toshochan = '#tokyotosho-api'; #join to this channel first
my $announcechan = '#Leopard-Raws'; #type your channel here
my @exps = ('^\[Leopard-Raws\].+$', '^\[Raws-4U\].+$', '^\[Yousei-raws\].+$');

sub event_privmsg {
    my ($server, $data, $nick, $address) = @_;
    my ($target, $text) = split(/ :/, $data, 2);
    if (($target eq $toshochan) && ($nick eq $toshobot) && ($text =~ m/^Torrent\x1E.+$/i)){
        my @tokens = split(/\x1E/, $text);
        my ($tid, $category, $catnum, $release, $url, $size, $comment) = @tokens[1..7];
        foreach my $exp (@exps) {
            if ($release =~ m/$exp/i) {
                $server->command("MSG BotServ say $announcechan ".chr(2).chr(3)."10Release: ".chr(3)."11[$category]".chr(2)." ".chr(3)."3$release");
                $server->command("MSG BotServ say $announcechan ".chr(2).chr(3)."12Torrent: ".chr(2)." $url");
                if ($comment) {
                    $server->command("MSG BotServ say $announcechan ".chr(3)."10Size: $size | Comment: $comment");
                }
                else {
                    $server->command("MSG BotServ say $announcechan ".chr(3)."10Size: $size");
                }
                last;
            }
        }
    }
}

Irssi::signal_add('event privmsg', 'event_privmsg');