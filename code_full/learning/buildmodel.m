function jointmodel = buildmodel(name, pos, location, idx, parent, sbin)
% This function merges together separate part models into a tree structure

globals;

jointmodel.bias    = struct('w',{},'i',{});
jointmodel.filters = struct('w',{},'i',{});
jointmodel.defs    = struct('w',{},'i',{},'anchor',{});
jointmodel.components{1} = struct('biasid',{},'filterid',{},'defid',{},'parent',{});

model0 = initmodel(pos,sbin);
jointmodel.maxsize  = model0.maxsize;
jointmodel.interval = model0.interval;
jointmodel.sbin = model0.sbin;
jointmodel.len = 0;
jointmodel.parent = parent;

% add pren
for p = 1:length(parent)
  assert(parent(p) < p);
  load([cachedir name '_part' num2str(p)]);

  % add bias
  component.biasid = [];
  if parent(p) == 0
    nb  = length(jointmodel.bias);
    b.w = 0;
    b.i = jointmodel.len + 1;
    jointmodel.bias(nb+1) = b;
    jointmodel.len = jointmodel.len + numel(b.w);
    component.biasid = nb+1;
  else
    component.biasid = zeros(max(idx(:,parent(p))), max(idx(:,p)));
    for l = 1:max(idx(:,parent(p)))
      for k = 1:max(idx(:,p))
        % Note parent and child's mixture pair must co-occur!!!
        % Then the bias computed is meaningful.
        ind = (idx(:,parent(p)) == l & idx(:,p) == k);
        if sum(ind) == 0, continue, end;
        nb = length(jointmodel.bias);
        b.w = 0;
        b.i = jointmodel.len + 1;
        jointmodel.bias(nb+1) = b;
        jointmodel.len = jointmodel.len + numel(b.w);
        component.biasid(l,k) = nb+1;
      end
    end
  end

  % add filter
  component.filterid = [];
  for k = 1:max(idx(:,p))
    nf  = length(jointmodel.filters);
    f.w = model.filters(k).w;
    f.i = jointmodel.len + 1;
    jointmodel.filters(nf+1) = f;
    jointmodel.len = jointmodel.len + numel(f.w);
    component.filterid = [component.filterid nf+1];
  end

  % add deformation parameter
  component.defid = [];
  if parent(p) > 0
    component.defid = zeros(max(idx(:,parent(p))), max(idx(:,p)));
    for l = 1:max(idx(:,parent(p)))
      for k = 1:max(idx(:,p))
        % Note parent and child's mixture pair must co-occur!!!
        % Then the deformation computed is meaningful.
        ind = (idx(:,parent(p)) == l & idx(:,p) == k);
        if sum(ind) == 0, continue, end;
        nd  = length(jointmodel.defs);
        d.w = [0.01 0 0.01 0];
        d.i = jointmodel.len + 1;
        x = mean(location(ind,1,p) - location(ind,1,parent(p)));
        y = mean(location(ind,2,p) - location(ind,2,parent(p)));
        d.anchor = round([x+1 y+1 0]);
        jointmodel.defs(nd+1) = d;
        jointmodel.len = jointmodel.len + numel(d.w);	
        component.defid(l,k) = nd+1;
      end
    end
  end

  component.parent = parent(p);
  np = length(jointmodel.components{1});
  jointmodel.components{1}(np+1) = component;
end