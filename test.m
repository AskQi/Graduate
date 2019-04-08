% 这里加载读取各个实体的模块
drawing_entialls_dir = dir('DrawingEntialls');
if ~isempty(drawing_entialls_dir.name), cd(drawing_entialls_dir.name), end
read_entialls_fcn_file=dir('DrawingEntialls_*.m');
exp='\d{3,4}';
[fcn_names_number,ziduan]=size(read_entialls_fcn_file);

for j=1:fcn_names_number
    read_fcn_name=read_entialls_fcn_file(j).name;
    this_num= cellstr(regexp(read_fcn_name,exp,'match'));
    support_drawing_fcn_type(j)=transpose(str2num(cell2mat(this_num)));
    support_read_fcn_name="DrawingEntialls_"+this_num;
    support_read_fcns{j} = str2func(support_read_fcn_name);
end
cd ..
