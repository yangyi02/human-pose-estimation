function det = BUFFY_transback(det)

% -------------------
% Generate candidate keypoint locations
% Our model produce 18 keypoint locations including joints and their middle points
% But for BUFFY evaluation, we will only use the original 10 joints
I = [1 2 3 4 5  6  7 8  9  10];
J = [1 2 3 5 11 13 7 15 10 18];
A = [1 1 1 1 1  1  1 1  1  1];
Transback = full(sparse(I,J,A,10,18));

for n = 1:numel(det)
	for i = 1:numel(det(n).obj)
		if isempty(det(n).obj(i).point), continue, end
		det(n).obj(i).point = Transback * det(n).obj(i).point;
	end
end
