# JHF_BreadthFirstSearch-Algorithm-

% The node matrix or arrays need to be defined manually.  The node matrix or arrays can be all
% numerical values or can be a cell matrix containing all lower or upper alphabetical
% elements. This code does not work for directed networks.

% Numerical Notes.....
% If the arrays are numerical then the code will ask if the arrays are
% in 0...inf format or 1...inf format since MATLAB only works in the 1...inf format.

% Alphabetical Notes.....
% This code does work if lowercase or a mix of alphabetical
% cases are used but in reality the code will convert to uppercase. For example,
% if you want to actuall use 'a' and 'A' node names then this is not possible
% since this code will interpret these both as 'A'. An error message will be 
% printed and the program will exit if a mix of elements (numerical and alpha) or lowercase letters are used.

% Multiple examples of source and target arrays can be found below. The
% unconnected nodes should be defined as 'inf' and the path/connection from
% a node to itself can be defined as '0' but can also be defined as 'inf'. 

% Depending on the array types this code will identify if the arrays
% are numerical or alphabetical. The code will ask if you
% want to find all BFS paths for each node or find the BFS of a single node.
% The output will show the BFS path in the same format (numerical 0...inf,
% numerical 1...inf, or alpha).

% Use these examples below as a reference. One mandatory rule is that the
% variables 's' and 't' must be used. You can define your network
% using 's' and 't'.

% This code will handle defined networks that do not start at 0 or 1 or 'A' or 'a'. Your network can start at
% node 5 for example and end at node 20.
% This code will also handle gaps or disconnected nodes if your network is
% defined that way. Any disconnected nodes from a source will not be
% printed.



% Normal alphabetical example arrays
% s = [{'A'} {'A'} {'A'} {'A'} {'B'} {'B'} {'B'} {'B'} {'B'}];
% t = [{'C'} {'E'} {'D'} {'B'} {'F'} {'J'} {'G'} {'I'} {'H'}];

% Example of node network with the minimum node not being a value of 'A'
% s = [{'B'} {'B'} {'B'} {'B'} {'C'} {'C'} {'C'} {'C'} {'C'}];
% t = [{'D'} {'F'} {'E'} {'C'} {'G'} {'K'} {'H'} {'J'} {'I'}];

% Example of a node in between min and max node values that is not
% connected to any other node
% s = [{'A'} {'A'} {'A'} {'A'} {'B'} {'B'} {'B'} {'B'} {'L'}];
% t = [{'C'} {'E'} {'D'} {'B'} {'F'} {'J'} {'G'} {'I'} {'H'}];

% Normal numerical example arrays
% s = [1 1 1 1 2 2 2 2 2];
% t = [3 5 4 2 6 10 7 9 8];

% Example of node network with the minimum node not being a value of 1 or 0
% s = [2 2 2 2 3 3 3 3 3];
% t = [4 6 5 3 7 11 8 10 9];

% Example of a node in between min and max node values that is not
% connected to any other node
% s = [1 1 1 1 2 2 2 2 12];
% t = [3 5 4 2 6 10 7 9 8];
