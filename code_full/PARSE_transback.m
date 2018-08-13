function det = PARSE_transback(det)

% -------------------
% Generate candidate keypoint locations
% Our model produce 26 keypoint locations including joints and their middle points
% But for PARSE evaluation, we will only use the original 14 joints
I = [1  2  3  4  5  6  7  8  9  10 11 12 13 14];
J = [14 12 10 22 24 26 7  5  3  15 17 19 2  1];
A = [1  1  1  1  1  1  1  1  1  1  1  1  1  1];
Transback = full(sparse(I,J,A,14,26));

for n = 1:numel(det)
	for i = 1:numel(det(n).obj)
		if isempty(det(n).obj(i).point), continue, end
		det(n).obj(i).point = Transback * det(n).obj(i).point;
	end
end
