% Jacob Foster
% 2/28/2023
% CE-642
% Week 8 Assignment - Breadth First Search Algorithm


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

clc
clear all
close all
format=0;

% Use these examples below as a reference. One mandatory rule is that the
% variables 's' and 't' must be used. You can define your network
% using 's' and 't'.

% This code will handle defined networks that do not start at 0 or 1 or 'A' or 'a'. Your network can start at
% node 5 for example and end at node 20.
% This code will also handle gaps or disconnected nodes if your network is
% defined that way. Any disconnected nodes from a source will not be
% printed.

s = [{'A'} {'A'} {'B'} {'B'} {'C'} {'E'} ];
t = [{'B'} {'C'} {'D'} {'E'} {'F'} {'F'} ];


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

%---------------Start Array Handling----------------------
if(exist('s','var') && exist('t','var'))
    if(size(s,2)~=size(t,2)) % Check if the dimensions of the matrix are the same
        fprintf('Invalid source and target arrays! Both array dimensions need to be the same. Exiting Program... \n');
        return
    end
    if(iscell(s) && iscell(t))
        numorletter_s=0;
        numorletter_t=0;
        lock=false;
        lock2=false;
        for j = 1:size(s,2)
            if(~isequal(cell2mat(s(j)),'0') && ~isequal(cell2mat(s(j)),'inf')) % If cell value is not 0 or inf then it must be a real, meaningful value
                % If cell value contains an uppercase, does not contain a
                % lower case, and does not contain a number then it is a
                % valid element.
                if (any(regexp(cell2mat(s(j)) ,'[A-Z]')) && ~any(regexp(cell2mat(s(j)) ,'[0-9]')) && ~any(regexp(cell2mat(s(j)) ,'[a-z]')))
                    if(lock==true && numorletter_s==1) % If a valid element has already been found and is opposite of this newly found element then there is a mix of element types.
                        fprintf('Invalid source array! There is a mix of numbers and character elements in your source array. Exiting Program... \n');
                        return
                    elseif(lock2==true && numorletter_s==0)
                        fprintf('Invalid source array! There is a mix of lower case and upper case elements in your source array. Exiting Program... \n');
                        return
                    else
                        numorletter_s = 0;
                        lock=true;
                    end
                % If cell value does not contain an uppercase, does not contain a
                % lower case, and does contain a number then it is a
                % valid element.
                elseif (~any(regexp(cell2mat(s(j)) ,'[A-Z]')) && any(regexp(cell2mat(s(j)) ,'[0-9]')) && ~any(regexp(cell2mat(s(j)) ,'[a-z]')))
                    if(lock==true && numorletter_s==0) % If a valid element has already been found and is opposite of this newly found element then there is a mix of element types.
                        fprintf('Invalid source array! There is a mix of numbers and character elements in your source array. Exiting Program... \n');
                        return
                    else
                        numorletter_s = 1;
                        lock=true;
                    end
                % If cell value does not contain an uppercase, does contain a
                % lower case, and does not contain a number then it is a
                % valid element.
                elseif (~any(regexp(cell2mat(s(j)) ,'[A-Z]')) && ~any(regexp(cell2mat(s(j)) ,'[0-9]')) && any(regexp(cell2mat(s(j)) ,'[a-z]')))
                    if(lock==true && numorletter_s==1) % If a valid element has already been found and is opposite of this newly found element then there is a mix of element types.
                        fprintf('Invalid source array! There is a mix of numbers and character elements in your source array. Exiting Program... \n');
                        return
                    elseif(lock==true && numorletter_s==0)
                        fprintf('Invalid source array! There is a mix of lower case and upper case elements in your source array. Exiting Program... \n');
                        return
                    else
                        numorletter_s = 0;
                        lock2=true;
                    end
                elseif (~any(regexp(cell2mat(s(j)) ,'[0-9]'))) 
                    fprintf('Invalid source array! There is at least one node name with a mix of lower case and upper case. Please use one case only. Exiting Program... \n');
                    return
                end
            end
        end
        for j = 1:size(s,2)
            if(~isequal(cell2mat(s(j)),'0') && ~isequal(cell2mat(s(j)),'inf')) % If cell value is not 0 or inf then it must be a real, meaningful value
                % If cell value contains an uppercase, does not contain a
                % lower case, and does not contain a number then it is a
                % valid element.
                if (any(regexp(cell2mat(s(j)) ,'[A-Z]')) && ~any(regexp(cell2mat(s(j)) ,'[0-9]')) && ~any(regexp(cell2mat(s(j)) ,'[a-z]')))
                    if(lock==true && numorletter_t==1) % If a valid element has already been found and is opposite of this newly found element then there is a mix of element types.
                        fprintf('Invalid target array! There is a mix of numbers and character elements in your target array. Exiting Program... \n');
                        return
                    elseif(lock2==true && numorletter_t==0)
                        fprintf('Invalid target array! There is a mix of lower case and upper case elements in your target array. Exiting Program... \n');
                        return
                    else
                        numorletter_t = 0;
                        lock=true;
                    end
                % If cell value does not contain an uppercase, does not contain a
                % lower case, and does contain a number then it is a
                % valid element.
                elseif (~any(regexp(cell2mat(s(j)) ,'[A-Z]')) && any(regexp(cell2mat(s(j)) ,'[0-9]')) && ~any(regexp(cell2mat(s(j)) ,'[a-z]')))
                    if(lock==true && numorletter_t==0) % If a valid element has already been found and is opposite of this newly found element then there is a mix of element types.
                        fprintf('Invalid target array! There is a mix of numbers and character elements in your target array. Exiting Program... \n');
                        return
                    else
                        numorletter_t = 1;
                        lock=true;
                    end
                % If cell value does not contain an uppercase, does contain a
                % lower case, and does not contain a number then it is a
                % valid element.
                elseif (~any(regexp(cell2mat(s(j)) ,'[A-Z]')) && ~any(regexp(cell2mat(s(j)) ,'[0-9]')) && any(regexp(cell2mat(s(j)) ,'[a-z]')))
                    if(lock==true && numorletter_t==1) % If a valid element has already been found and is opposite of this newly found element then there is a mix of element types.
                        fprintf('Invalid target array! There is a mix of numbers and character elements in your target array. Exiting Program... \n');
                        return
                    elseif(lock==true && numorletter_t==0)
                        fprintf('Invalid target array! There is a mix of lower case and upper case elements in your target array. Exiting Program... \n');
                        return
                    else
                        numorletter_t = 0;
                        lock2=true;
                    end
                elseif (~any(regexp(cell2mat(s(j)) ,'[0-9]'))) 
                    fprintf('Invalid target array! There is at least one node name with a mix of lower case and upper case. Please use one case only. Exiting Program... \n');
                    return
                end
            end
        end
        if(numorletter_t~=numorletter_s)
            fprintf('Invalid node arrays! Both arrays must be of the same type. Exiting Program... \n');
            return
        else
            numorletter = numorletter_s;
        end
        loc_min = inf;
        for i=1:size(s,2)
            loc_s(i) = letters2numbers(cell2mat(s(i)));
            loc_min = min(loc_min,loc_s(i));
            loc_t(i) = letters2numbers(cell2mat(t(i)));
            loc_min = min(loc_min,loc_t(i));
        end
        loc_min = loc_min - 1;
        [cnt_unique, unique_s] = hist(cat(1,loc_s,loc_t),unique(cat(1,loc_s,loc_t)));
        node_matrix=zeros(size(unique_s,2),size(unique_s,2));
        for i=1:size(loc_s,2)
            node_matrix(loc_s(i)-loc_min,loc_t(i)-loc_min) = loc_t(i)-loc_min;
        end
        for i=1:size(loc_t,2)
            node_matrix(loc_t(i)-loc_min,loc_s(i)-loc_min) = loc_s(i)-loc_min;
        end
        node_matrix(node_matrix==0)=inf;
    elseif(iscell(s) || iscell(t))
        fprintf('Invalid source or target arrays! Both arrays must be the same type (cell array or numerical array). Exiting Program... \n');
        return
    else
        [cnt_unique, unique_s] = hist(cat(1,s,t),unique(cat(1,s,t)));
        node_matrix=zeros(size(unique_s,2),size(unique_s,2));
        loc_min = inf;
        loc_min = min(loc_min,min(s,[],'all'));
        loc_min = min(loc_min,min(t,[],'all'));
        loc_min = loc_min - 1;
        for i=1:size(s,2)
            node_matrix(s(i)-loc_min,t(i)-loc_min) = t(i)-loc_min;
        end
        for i=1:size(t,2)
            node_matrix(t(i)-loc_min,s(i)-loc_min) = s(i)-loc_min;
        end
        node_matrix(node_matrix==0)=inf;
        numorletter = 1;
    end

    %---------------End Array Handling----------------------
    %---------------Start Matrix Handling-------------------
    if(size(node_matrix,1)~=size(node_matrix,2)) % Check if the dimensions of the matrix are the same
        fprintf('Invalid node matrix! Both dimensions need to be the same. Exiting Program... \n');
        return
    end
    if(ischar(node_matrix)) % Check if the matrix is a character array (a mix of numbers and letters)
        fprintf('Invalid node matrix! There is a mix of numbers and character elements in your node matrix. Exiting Program... \n');
        return
    end

    loc_node_matrix=node_matrix;

    if(numorletter) % If the node matrix is all numerical, ask the user if the numerical format is 0...inf or 1...inf
        valid = false;
        while valid == false % Ensure that a valid node is selected. Node needs to be within node matrix range.
            format=input('Are your graphical nodes in the 0...inf format? (Y/N/EXIT): ','s');
            format=lower(format);
            if (isempty(format)) % If answer was empty then exit
               fprintf('Exiting Program....... \n');
               return
             % If the answer was the same size as 'exit' or 4 then continue 
             % (this check is needed since an answer of a different size of 4 
             % would through an error in the next line of code).
            elseif(size('exit')==size(format)) 
                if(all(format=='exit'))
                    fprintf('Exiting Program....... \n');
                    return
                else
                    fprintf('Invalid input! Please enter Y, N, or EXIT. Try again. \n');
                end
            else
                if(format=='y')
                    format=1;
                    valid = true;
                elseif(format=='n')
                    format=0;
                    valid = true;
                else
                    fprintf('Invalid input! Please enter Y, N, or EXIT. Try again. \n');
                end
            end
        end
    end

    % Ask the user if all BFS paths should be found or from just one specific node
    valid = false;
    while valid == false % Ensure that a valid node is selected. Node needs to be within node matrix range.
        loopall=input('Do you want to find the BFS path for all nodes? (Y/N/EXIT)>','s');
        loopall=lower(loopall);
        if (isempty(loopall)) % If answer was empty then exit
           fprintf('Exiting Program....... \n');
           return
        elseif(size('exit')==size(loopall))
            if(all(loopall=='exit'))
               fprintf('Exiting Program....... \n');
               return
            end
        end
        if(loopall=='n')
            valid=true;
            if(numorletter)
               valid2 = false;
               while valid2 == false % Ensure that a valid node is selected. Node needs to be within node matrix range.
                   s=input('Enter the source node number (#/EXIT): ','s'); 
                   s=lower(s);
                   if(isempty(s)) % If answer was empty then exit
                       fprintf('Exiting Program....... \n');
                       return
                   elseif(size('exit')==size(s))
                       if(all(s=='exit'))
                           fprintf('Exiting Program....... \n');
                           return
                       end
                   end
                   if ~any(regexp(s ,'[0-9]'))
                       fprintf('Invalid node! Please only enter numerical node values. Try again. \n');
                   else
                       s=str2num(s);
                       if(format==1)
                          s=s+1; % Convert node to 1..inf format
                       end
                       if(s <= size(node_matrix,1))
                           valid2 = true;
                       else
                           fprintf('Invalid node! That node is out of bounds of the node matrix. Try again. \n');
                       end
                   end
               end
            else
               valid2=false;
               while valid2==false
                    s=input('Enter the source node letter(s)(A...Z...AA...ZZ...inf is accepted) (#/EXIT): ','s');
                    if(isempty(s)) % If answer was empty then exit
                       fprintf('Exiting Program....... \n');
                       return
                    elseif(size('exit')==size(s))
                        if(all(lower(s)=='exit'))
                            fprintf('Exiting Program....... \n');
                            return
                        end
                    end
                    if (any(regexp(s ,'[0-9]')))
                        fprintf('Invalid input! Please enter all uppercase letter nodes with no numbers or EXIT. Try again. \n');
                    else
                        if(lower(s)~=s) % If user select node is all uppcase then continue
                           t = letters2numbers(s);
                            if(t <= size(node_matrix,1)) % If user select node is within node network then continue
                                valid2=true;
                            else
                                fprintf('Invalid input! That node is out of bounds of the node matrix. Try again. \n');
                            end
                        else
                            fprintf('Invalid input! Please enter all uppercase letter nodes or EXIT. Try again. \n');
                        end
                    end
               end
               s=letters2numbers(s); % Convert the user selected source node to a number
            end
            Visted = BFS(loc_node_matrix, s, format, loc_min); % Perform BFS function and output the BFS path for the single user selected node
            if(numorletter) % For numerical nodes
                fprintf('---------------------------------------\n');
                fprintf('The BFS path from node %d is: \n',s-format);
                fprintf('%d \n',Visted);
            else  % For alphabetical nodes
               for i=1:size(Visted,2)
                   loc_finaL_V{i} = numbers2letters(Visted(i));    
               end
               p=numbers2letters(s-format);
               fprintf('---------------------------------------\n');
               fprintf('The BFS path from node %c is: \n',p);
               fprintf('%c \n',cell2mat(loc_finaL_V(:)));
            end
        elseif(loopall=='y')
            valid=true;
            Visted=[];
            for t = 1:size(loc_node_matrix,1)
                Visted{t} = BFS(loc_node_matrix, t, format, loc_min); % Perform BFS function and output the BFS path for all nodes
                loc_finaL_V = [];
                if(numorletter) % For numerical nodes
                   fprintf('---------------------------------------\n');
                   fprintf('The BFS path from node %d is: \n',t+loc_min-format);
                   fprintf('%d \n',cell2mat(Visted(t)));
                else % For alphabetical nodes
                   loc_V = cell2mat(Visted(t));
                   for i=1:size(loc_V,2)
                       loc_finaL_V{i} = numbers2letters(loc_V(i));    
                   end
                   Visted{t} = loc_finaL_V;
                   p=numbers2letters(t-format);
                   fprintf('---------------------------------------\n');
                   fprintf('The BFS path from node %c is: \n',p+loc_min);
                   fprintf('%c \n',cell2mat(loc_finaL_V(:)));
                end
            end
        else % If answer from the question 'Do you want to find the BFS path for all nodes?' was not Y, N, or EXIT then send error.
            fprintf('Invalid input! Please enter Y, N, or EXIT. Try again. \n');
        end
    end
    fprintf('---------------------------------------\n');
    %---------------End Matrix Handling-------------------
else
    fprintf('Variables "s" and "t" are not defined. Exiting Program....... \n');
    return
end

function [V] = BFS(BFS_matrix, s, format, offset)
    % This is an implementation of the Breadth First Search Algorithm
    % which finds the sesarching path by following/finding the nearest nodes 
    % and expanding outwards to the nearest children.
    
    % n: the number of nodes in the network;
    % s: source node index;
    % V = Visted Nodes Array
    % Q = Queue to Seach Array
    % format - is used for numerical nodes in order to convert from 1...inf
    % to 0...inf format.

    %Author: Jacob Foster. 02/28/2023


    n=size(BFS_matrix,1);
    V(1:n) = inf;     
    Q(1:n) = inf;     

    V(1)=s;
    loc_s = s;
    Q=[];
    y=1;
    v=2;
    while v<n % If some nodes are still alive, keep searching
        for i=1:n
            if BFS_matrix(loc_s,i)~=0 && BFS_matrix(loc_s,i)~=inf
                if(~any(V(:) == i))
                    Q(y)=i;
                    y=y+1;
                    V(v)=i;
                    v=v+1;
                end
            end
        end
        if(isempty(Q)||all(BFS_matrix(loc_s,:)==inf))
            for i=loc_s+1:n+1
                if(any(V(:) == i))
                    loc_s = i;
                    break
                else
                    v=v+1;
                end
            end
        end
        q = 1;
        while ~isempty(Q)
            loc_s = Q(q);
            for i=1:n
                if BFS_matrix(loc_s,i)~=0 && BFS_matrix(loc_s,i)~=inf
                    if(~any(V(:) == i))
                        Q(y)=i;
                        y=y+1;
                        V(v)=i;
                        v=v+1;
                    end
                end
            end
            Q(q)=[];
            y=y-1;
        end
    end
    if(format==1)
        V(:) = V(:) - 1;
    end
    if(offset > 0)
        V(:) = V(:) + 1;
    end
    V(V==inf)=[];
end


function num = letters2numbers( word ) % Convert uppercase letter to number
    asc = double( upper(word) );    % http://www.asciitable.com/
    if(size(asc,2)>1)
        num = 26*size(asc,2) + asc(1) - double('Z') ;  
    else
        num = 26 + asc - double('Z');
    end
end

function word = numbers2letters( num ) % Convert number to uppercase letter
    multi = ceil(num/26);    % http://www.asciitable.com/
    if(multi>1)
        word = char(num + double('A') - 1);
        for i=1:multi
            word = word + word;
        end
    else
        word = char(num + double('A') - 1);
    end
end