function neg = INRIA_data(name)

globals;

fprintf('Collet negative training and testing data from %s.\n', name);

filename = [name '_data'];
try
  load([cachedir filename]);
catch
  trainfrs = 615:1832;  % Training frames for negative on INRIA
  
  % -------------------
  % Grab neagtive image information
  negims = 'data/INRIA/%.5d.jpg';
  neg = struct('im', cell(1, length(trainfrs)));
  for n = 1:length(trainfrs)
    fr = trainfrs(n);
    neg(n).im = sprintf(negims,fr);
  end
  
  save([cachedir filename], 'neg');
end