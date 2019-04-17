Hello! Welcome to the readme for my command-line Ruby chess game for 2-player hotseat.

All standard chess rules have been coded, including king- and queen-side castling, pawn en-passant captures, and pawn promotions.

The game auto-detects check, checkmate, and the 4 draw conditions: stalemate, "dead position", threefold repetition, and the fifty-move rule.

All games are saved in the Portable Game Notation (PGN) standard for chess programs in a game.pgn file that should be compatible with all other PGN-compliant chess programs.

Move commands are simply the file and rank of the piece you wish to move followed by the file and rank of the destination square. Ex: a2a4 would move white's leftmost pawn from starting position up two squares. Players are informed if a move is invalid and prompted to go again.
