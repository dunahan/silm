-- Schema: getopt
-- Contains the functions and temporary tables used by
-- the getopt include.
create schema getopt;

-- Table: options
-- Temporary table that holds the parsed option key->value tuples.
create table getopt.options (
	name varchar not null unique,
	value varchar
);

-- Table: arguments
-- Temporary table that holds all parsed arguments.
create table getopt.arguments (
	position int not null unique,
	value varchar not null
);

-- Function: init
create function getopt.init(str varchar, req_o varchar) returns void as
$_$
	require 'getoptlong_inline.rb';
	require 'shellwords';
	return if str == "" || str.nil?
	return if req_o == "" || req_o.nil?

	opt = []

	all = []

	req_o = req_o.strip.split(" ").map{|x| x.strip}.reject{|x| x == ""}
	req_o.each do |n|
	   raise "Unknown option #{n}" unless n =~ /^([^=\?]+)(\?|=?)$/
	   n = $1

	   next if all.index(n)

	   o = $2 == "="
	   o2 = $2 == "?"
	   all << n
	   # xxxfix kill -h: next if o == "h" && (!o && !o2)
	   opt << [(n.size > 1 ? "--" : "-") + n.downcase, o ? GetoptLong::REQUIRED_ARGUMENT :
		   o2 ? GetoptLong::OPTIONAL_ARGUMENT : GetoptLong::NO_ARGUMENT
	   ]
	end

	optarg = ""
	optarga = ""
	optv = {}
	arg = []


	arg = Shellwords.shellwords(str)

	# Fix missing -- for multichar options
	arg.map! {|x| x =~ /^-[^\s-]{2,}/i ? "-" + x : x }

	arg = GetoptLong.new(arg, *opt).each {|k,v|
	   k = $1 if k =~ /^--?(.+)$/
	   v = $1 if v =~ /^=(.+)$/
	   optv[k] = v
	}

	optarg = str
	optarga = arg.join(" ")
	
	PL.exec("truncate getopt.arguments;")
	PL.exec("truncate getopt.options;")

	pln = PL::Plan.new("insert into getopt.arguments (position, value) values($1, $2);", ['int4', 'varchar']).save
	arg.each_with_index {|aa, i|
		pln.exec([i, aa])
	}
	pln = PL::Plan.new('insert into getopt.options ("name", "value") values($1, $2);', ['varchar', 'varchar']).save
	optv.each {|k,v|
		pln.exec([k, v])
	}

$_$ language 'plruby';

-- Function: argc()
create function getopt.argc() returns int as
$_$ select count(*)::int from getopt.arguments; $_$ language sql;

-- Function: arg(int)
create function getopt.arg(int) returns varchar as
$_$
	select value from getopt.arguments a where a.position = $1;
$_$ language sql;

-- Function: opt(varchar)
create function getopt.opt(varchar) returns boolean as
$_$
	select count(*) > 0 from getopt.options o where o.name = $1;
$_$ language sql;

-- Function: optv
create function getopt.optv(varchar) returns varchar as
$_$
	select value from getopt.options o where o.name = $1;
$_$ language sql;

-- Function: reset
create function getopt.reset() returns void as
$_$
	truncate getopt.arguments;
	truncate getopt.options;
$_$ language sql;


-- Table: commands
-- Temporary table that holds all shellwords-parsed commands.
create table getopt.commands (
	position int not null unique,
	value varchar
);

-- Function: commandsplit
create function getopt.commandsplit(text varchar, splitat varchar) returns int as
$_$
	require 'shellwords'
	PL.exec("truncate getopt.commands;")
	cmdx = []
	sw = Shellwords.shellwords(text)
	cmd = []
	sw.each do |n|
		if n == splitat
			cmdx << cmd if cmd.size > 0
			cmd = []
			next
		end
		cmd << n
	end
	cmdx << cmd if cmd.size > 0
	cmdx.map! {|cmd|
		ret = " "
		cmd.each do |param|
			if param.index(" ").nil?
				ret << param + " "
			else
				ret << '"' + param + '" '
			end
		end
		ret.strip
	}
	cmdx.flatten!
	pln = PL::Plan.new("insert into getopt.commands (position, value) values($1, $2);", ['int4', 'varchar'])
	cmdx.each_with_index {|c, i|
		pln.exec([i, c])
	}
	return cmdx.size
$_$ language 'plruby';

-- Function: comandget
create function getopt.commandget(int) returns varchar as
$_$
	select value from getopt.commands c where c.position = $1;
$_$ language sql;

-- Function: commandc
create function getopt.commandc() returns int as
$_$
	select count(*)::int from getopt.commands;
$_$ language sql;

-- Function: shellwords_as_array
create function getopt.shellwords_as_array(varchar) returns varchar[] as
$_$
	line = args[0].lstrip
	words = []
	until line.empty?
		field = ''
		loop do
			if line.sub!(/\A"(([^"\\]|\\.)*)"/, '') then
				snippet = $1.gsub(/\\(.)/, '\1')
			elsif line =~ /\A"/ then
				raise ArgumentError, "Unmatched double quote: #{line}"
			elsif line.sub!(/\A'([^']*)'/, '') then
				snippet = $1
			elsif line =~ /\A'/ then
				raise ArgumentError, "Unmatched single quote: #{line}"
			elsif line.sub!(/\A\\(.)?/, '') then
				snippet = $1 || '\\'
			elsif line.sub!(/\A([^\s\\'"]+)/, '') then
				snippet = $1
			else
				line.lstrip!
				break
			end
			field.concat(snippet)
		end
		words.push(field)
	end
	words
$_$
language 'plruby';

-- Function: shellwords_as_table
create function getopt.shellwords_as_table(varchar) returns setof varchar as
$_$
	
	i = PL.context || 1
	vl = shellwords_as_array(args[0])[i - 1]
	PL.context = i + 1
	vl
$_$
language 'plruby';
