function[centroid, pointsInCluster, assignment, clustersSize]= bpmeans(data, lambda)
% function bpmeans()

% data 
% lambda = 20; 
% load tmp


% size(data,1) : number of the instances
% size(data,2) : dimensionality of the data

% data = X
% nbCluster = 5;
% load tmp

nbCluster = 1; % size(data,1)/10;
% nbClusterNow = 1;  % current number of clusters

% usage
% function[centroid, pointsInCluster, assignment]=
% myKmeans(data, nbCluster)
%
% Output:
% centroid: matrix in each row are the Coordinates of a centroid
% pointsInCluster: row vector with the nbDatapoints belonging to
% the centroid
% assignment: row Vector with clusterAssignment of the dataRows
%
% Input:
% data in rows
% nbCluster : nb of centroids to determine
%
% (c) by Christian Herta ( www.christianherta.de )
%
%
data_dim = length(data(1,:));
nbData   = length(data(:,1));


% init the centroids randomly
data_min = min(data);
data_max = max(data);
data_diff = data_max - data_min ;
% every row is a centroid
centroid = ones(nbCluster, data_dim) .* rand(nbCluster, data_dim);
for i=1 : 1 : length(centroid(:,1))
    centroid( i , : ) =   centroid( i , : )  .* data_diff;
    centroid( i , : ) =   centroid( i , : )  + data_min;
end
% end init centroids

% no stopping at start
pos_diff = 1.;

% main loop until
iterAll = 1; 
while pos_diff > 0.0
    iterAll = iterAll + 1; 
    if iterAll > 20
        break; 
    end
%     nbClusterNow
    nbCluster
    % E-Step
    assignment = []; % per data 
    % assign each datapoint to the closest centroid
    for d = 1 : length( data(:, 1) );
        
        min_diff = ( data( d, :) - centroid( 1,:) );
        min_diff = min_diff * min_diff';
        curAssignment = 1;
        
        for c = 2 : nbCluster;
%             c
            diff2c = ( data( d, :) - centroid( c,:) );
            diff2c = diff2c * diff2c';
            if( min_diff >= diff2c)
                curAssignment = c;
                min_diff = diff2c;
            end
        end
        
        if( min_diff < lambda )
            % keep it ;
        else
            nbCluster =  nbCluster + 1;
            disp([ 'Adding new clusters : min_diff '  num2str(min_diff) ] )
            curAssignment = nbCluster;
            centroid(end+1, :) = (rand( 1, data_dim) .* data_diff) + data_min;
        end
        
        % assign the d-th dataPoint
        assignment = [ assignment; curAssignment];
        
    end
    
    % for the stoppingCriterion
    oldPositions = centroid;
    
    % M-Step
    % recalculate the positions of the centroids
    centroid = zeros(nbCluster, data_dim);
    pointsInCluster = zeros(nbCluster, 1);
    
    for d = 1: length(assignment);
        centroid( assignment(d),:) = data(d,:) + centroid( assignment(d),:)  ;
        pointsInCluster( assignment(d), 1 ) = pointsInCluster( assignment(d), 1 ) + 1;
    end
    
    for c = 1: nbCluster;
        if( pointsInCluster(c, 1) ~= 0)
            centroid( c , : ) = centroid( c, : ) / pointsInCluster(c, 1);
        else
            % set cluster randomly to new position
%             centroid( c , : ) = (rand( 1, data_dim) .* data_diff) + data_min;
            centroid( c , : ) = []; 
            disp('I need to remove this bitch! ')
            
        end
    end
    
    %stoppingCriterion
    pos_diff = sum (sum( (centroid - oldPositions).^2 ) );
%     pos_diff
clustersSize = nbCluster; 
end