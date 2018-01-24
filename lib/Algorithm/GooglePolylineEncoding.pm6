use v6.c;
unit class Algorithm::GooglePolylineEncoding:ver<0.0.1>;

multi sub encode-number ( Real $value is copy where * < 0 ) returns Str is export {
    $value = round( $value * 1e5 );
    $value = $value +< 1;
    $value = $value +& 0xffffffff;
    
    $value = +^ $value;
    $value = $value +& 0xffffffff;
    
    return encode-shifted( $value );
}

multi sub encode-number ( Real $value is copy ) returns Str is export {
    $value = round( $value * 1e5 );
    $value = $value +< 1;            
    $value = $value +& 0xffffffff;
        
    return encode-shifted( $value );
}

sub encode-shifted ( Int $value is copy ) returns Str {

    my $bin = $value.base(2);

    unless $bin.chars %% 5 {
        $bin = '0' x ( 5 - $bin.chars % 5 ) ~ $bin;
    }
    
    my @chunks = $bin.comb( /\d ** 5/ ).reverse.map( *.parse-base(2) );
    
    @chunks[0..*-2].map( { $_ = $_ +| 0x20 } );

    return @chunks.map( { $_ + 63 } ).map( { chr( $_ ) } ).join("");
}



=begin pod

=head1 NAME

Algorithm::GooglePolylineEncoding - blah blah blah

=head1 SYNOPSIS

  use Algorithm::GooglePolylineEncoding;

=head1 DESCRIPTION

Algorithm::GooglePolylineEncoding is ...

=head1 AUTHOR

Simon Proctor <simon.proctor@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2018 Simon Proctor

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
