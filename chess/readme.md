Hello! Welcome to the readme for my command-line Ruby chess game for 2-player hotseat.

All standard chess rules have been coded, including king- and queen-side castling, pawn en-passant captures, and pawn promotions.

The game auto-detects check, checkmate, stalemate, and dead position. Dead position detection is limited to KK, KBK, KNK, KBKB with bishops on same color. A player may also offer a draw at any time with the "draw" command, which can be accepted or rejected by the opponent.

All games are saved in the Portable Game Notation (PGN) standard for chess programs in a game.pgn file.

Move commands are simply the file and rank of the piece you wish to move followed by the file and rank of the destination square. Ex: a2a4 would move white's leftmost pawn from starting position up two squares. Players are informed if a move is invalid and prompted to go again.
