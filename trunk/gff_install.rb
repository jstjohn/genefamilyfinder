#! /usr/bin/env ruby

require 'ftools' 
require 'optparse'
require 'ostruct'

#######################################################
#  This is the installer script for gene family finder
#  To update the version of gff that gets installed 
#  follow the following steps
#  1. make the changes to our version of gff
#  2. coppy gff into a new file 
#  3. find every '/' character and replace it with '//'
#  4. find every '#{' and replace it with '/#{'
#  5. Make the following changes so that hard coded variables can be set by
#      the user while running this installer script
#    A. Change the variable program_name = "gff" to    program_name = "#{ins_options.program_name}"
#         within the class CommandArgs 
#    B. Change the variable db_base_path="/somepath" to   db_base_path = '#{ins_options.tracedb}'
#         within the class CommandArgs
#    C. Change the variable options.cpu = 1 to  options.cpu = #{ins_options.cpu}
#         within the class CommandArgs
#    D. Change the variable options.max_blast = 1000 to     options.max_blast = #{ins_options.max_blast}
#         within the class CommandArgs
#    E. Change the line "default is 1" to "default is #{ins_options.cpu}" in the class CommandArgs as is shown below:
#         # set the number of CPU's, defaults to 1
#         opts.on("-c", "--cpu NUMBER", Integer, "Run program on NUMBER of CPU's, default is #{ins_options.cpu}") do |num|
#    F. Make the following change similar to the one in step D also in the class CommandArgs:
#         opts.on("-m", "--max_hits NUMBER", Integer, 
#                 "Give the maximum NUMBER of blast hits, default is #{ins_options.max_blast}" ) do |num_hits|
#         
#  6. Coppy everything in the file and replace everything
#     in this file between <<-TILTHEEND and TILLTHEEND
#     with the stuff you just did.
#  7. Change the version variable in this file at the beginning of the FlagGetter class to reflect
#     the current version.






class FlagGetter
  
  def self.parse(args)
    
    version = "version 1.0 beta 2"
    
    
    ins_options = OpenStruct.new()
    ins_options.cpu = 1
    ins_options.max_blast = 1000
    ins_options.version = version
    ins_options.tracedb = ''
    ins_options.program_name = 'gff'
    ins_options.path = "/usr/bin"
    ins_options.overwrite = false
    
      
      welcome = <<-EOE
Thanks for trying Gene Family Finder: A Bioinformatic pipeline to identify gene 
family members from trace genome archives. Before installing this program you
need to install a few prerequisits if you have not already done so:

  1. Ruby gems 
  2. bioruby (after installing ruby gems type "sudo gem install bio", or install 
      as root without the "sudo")
      
EOE

    explanation = <<-EOE 
The minimal input for this program is:

          gff_install.rb -t [path to trace]
          
        Note: When inputting the path to the trace database, make sure that 
        the input starts with '/' and contains the full path to the lowest
        level directory that contains all of your trace archives you might
        want to search. However if you choose too low of a path, the program
        may take a very long time to find the trace databases. It would be a
        good idea to move all of your trace databases into their own folder. 
     
EOE

    ##########
    # Test for availability of ruby gems and 
    # necessary bio packages:
    #     require 'rubygems'
    #     require 'bio/sequence'
    #     require 'bio/db/fasta'
    #########
    
    begin
      require 'rubygems'
    rescue LoadError => msg
      puts msg
      puts "Ruby gems either not installed or not properly configured"
      puts "to work with this installation of ruby."
      print "\n", welcome
    end
    
    begin
      require 'bio/sequence'
    rescue LoadError => msg
      puts msg
      puts "Bioruby either not installed or not properly configured."
      puts "With root privaleges run \"gem update\" and then \"gem install bio\""
      puts "If that doesn't work it is possible ruby gems is configured to work with"
      puts "another installation of ruby on your computer."
      print "\n", welcome
    end
    
    begin
      require 'bio/db/fasta'
    rescue LoadError => msg
      puts msg
      puts "Bioruby either not installed or not properly configured."
      puts "With root privaleges run \"gem update\" and then \"gem install bio\""
      puts "If that doesn't work it is possible ruby gems is configured to work with"
      puts "another installation of ruby on your computer."
      print "\n", welcome
    end
    
    
    
    
    
    
    #################
    # => Define flags
    #################
    
    opts = OptionParser.new do |opts|
      opts.banner = "      Usage ruby gff_install.rb [install options]"
      opts.separator ""
      opts.separator ""
      opts.separator "Specific ins_options: "
      opts.separator ""
      
      opts.on("-t","--tracedb PATH", "Give the PATH to the folder that", 
      "contains all of the trace archives you want to search") do |path|
        raise OptionParser::ParseError, "#{path} is not a valid argument. Type -h for more information" if /^-/ =~ path
        path = path.chop if /\/$/ =~ path
        ins_options.tracedb = path
      end #opts.on
      
      #set the default # of CPU's
      opts.on("-c", "--cpu NUMBER", Integer, "Set the default number of CPU's to NUMBER, the default default is 1") do |num|
        ins_options.cpu = num
      end
      
      opts.on("-m", "--max_hits NUMBER", Integer, 
      "Set the default maximum NUMBER of blast hits, the default default is 1000" ) do |num_hits|
        #raise OptionParser::ParseError, "#{num_hits} is not a valid argument. Type -h for more information" if /^-/ =~ num_hits
        #raise OptionParser::ParseError, "#{num_hits} is not a valid integer argument. Type -h for more information" if (/[^\d]/ =~ num_hits)
        ins_options.max_blast = num_hits
      end
      
      opts.on("-p", "--program NAME", "Set the default program NAME, the default is \"gff\"",
      "Make sure the NAME doesn't have the \"/\" character") do |name|
        raise OptionParser::ParseError, "#{name} is not a valid NAME. Type -h for more information" if /\// =~ name
        ins_options.program_name = name
      end
      
      opts.on("-i", "--install PATH", "Give the PATH where you want this program to install",
      "default path is /usr/bin. It is good to put this program somewhere in your $path",
      "Type $PATH on the command line to see what folders are in your path",
      "PATH cannot contain the \"/\" character") do |path|
        raise OptionParser::ParseError, "#{path} is not a valid argument. Type -h for more information" if /^-/ =~ path
        path = path.chop if /\/$/ =~ path
        ins_options.tracedb = path
      end
      
        # Boolean switch.
        opts.on("-o", "--[no-]overwrite", "Overwrite any previous programs with the same name") do |o|
          ins_options.overwrite = o
        end




      # No argument, shows at tail.  This will print an ins_options summary.
      # Try it and see!
      opts.on_tail("-h", "--help", "Show this message") do
        print "\n", welcome
        puts opts
        print "\n", explanation
        exit 1
      end


      # Another typical switch to print the version.
      opts.on_tail("--version", "Show version" ) do
        puts version
        exit
      end
      
      
    end #opts.OptionParser
    
    opts.parse!(args)
    
    raise OptionParser::ParseError, "Missing required arguments" if ins_options.tracedb == ''
    return ins_options
  rescue OptionParser::ParseError => e
    puts ""
    puts e
    puts ""
    puts ""
    opts.parse(["-h"])
  end #self.parse(args)
end #class







begin
  ins_options = FlagGetter.parse(ARGV)
  
  if ! ins_options.overwrite
    if File.exist?(ins_options.path + "/" + ins_options.program_name)
      raise "File \"#{ins_options.program_name}\" already exists in \"#{ins_options.path}\" either rename \"#{ins_options.program_name}\" or run the installer again with -o to overwrite the old file."
    end
  end
  
  puts "makeing file #{ins_options.path}/#{ins_options.program_name}"
  
  f = File.open(ins_options.path + "/" + ins_options.program_name, "w+")
  
  f.puts <<-TILLTHEEND
#! /usr/bin/env ruby

#####################################################################################
# Conduct a similarity search of an input protein sequence against a 
# nucleotide sequence database (using TblastN)
# This program should eventually take an user-inputed sequence, e-value parameters, and 
# the name of a specific species database to search
# The output should be a list of subject ids from the matching DNA sequences (
# (over a certain e-value) and a list of the fasta sequences (accessed using the fastacmd)
#
# usage:  ./Blasts_commented.rb   
# 
# => This program uses many classes from the bio package
#
#
#
# you can see descriptions of the parameters for blastall, fastacmd, and other programs 
# listed in the ncbi blast documentation, at http://molbio.uoregon.edu/~bgillis/blast/
# or by using the --help arugment on the command line
#######################################################################################

require 'rubygems'
require 'bio/sequence'
require 'bio/db/fasta'
require 'ftools' 
require 'optparse'
require 'ostruct'
require 'date' #used in folder naming


#########################################################
# the class CommandLineArgs handles the flags
#
# => be sure to modify the variabe db_base_path to 
#     the path to your trace databases on your system
#     (the installer script does this for you)
#########################################################
class CommandLineArgs

#
# Return a structure describing the options
#
  def self.parse(args, time)
    program_name = "#{ins_options.program_name}"
    version = "version 1.0 beta 2"



    # hard-code the following variable into your system
    # try typing: locate *.nin
    # coppy the largest part of the path you can that includes
    # all of the trace databases you are interested in searching
    # don't include the '/' at the end of the path
    # (if you installed this program using the gff_install.rb script
    #   this step has already been done for you)
    db_base_path = '#{ins_options.tracedb}'

    month = time.month.to_s
    day = time.day.to_s
    year = time.year.to_s
    hour = time.hour.to_s
    min = time.min.to_s

    #######
    # Finds .nin databases located within specified db_base_path
    # removes duplicate databases from list and prepairs the name for use
    # makes a hash matching species name to database
    #######

    dbase_list = `find \#{db_base_path} -name *.nin`
    dbase_list = dbase_list.split(/\\n/)
    short_names = Hash.new()
    dbase_list.each_with_index { |full_path,i|
      dbase_list[i] = full_path.gsub(/(\\.\\d*\\.nin)|(\\.nin)/, '') #remove .digit.nin or .nin endings
    }
    dbase_list |= [] #removes duplicates

    dbase_list.each{ |full_path|
      index = full_path =~ /[^\\/\\s]*[^\\/\\s]$/
      partial = full_path[index,full_path.length]
      short_names[partial] = full_path
    }


    options = OpenStruct.new()
    options.initial_eval = '1'
    options.recip_eval = '1e-40'
    options.cpu = #{ins_options.cpu}
    options.verbose = false
    options.debug = false
    options.db_path = ''
    options.infile = ''
    options.max_blast = #{ins_options.max_blast}
    options.blast_filter = 'F'
    options.blast_comp_scoring = 'T'
    options.append = year + '_' + month + '_' + day + '-' + hour + '.' + min
    options.version


    welcome = <<-EOE
Thanks for trying Gene Family Finder: A Bioinformatic pipeline to identify gene 
family members from trace genome archives. If this is your first time using the
program and you haven't already done so, here are some changes you need to make: 

1. Have a working installation of Ruby (You won't see this message if you don't)
2. Install rubygems
3. Run either "sudo gem install bio" or just "gem install bio" if you are logged
    in as root.
4. We recommend running this file in a new work folder. It outputs a new folder 
    for each organism you run a job on, so your workspace can get cluttered 
    quickly.
5. Make sure you put the file that contains the FASTA amino acid sequence you
    want to search against the trace database in the same folder as this program.
    Also make sure that the FASTA file has nothing other than the defline and 
    the sequence.


EOE

    welcome2 = <<-EOE
    Thanks for trying Gene Family Finder: A Bioinformatic pipeline to identify gene 
    family members from trace genome archives.

EOE

    explanation = <<-EOE 
The minimal input for this program is:

          \#{program_name} -f [input filename] -d [database name or path]

        Note: When inputing the database name or path to database, keep in mind
        the program is case sensitive. Be sure to type in at least the shortest
        unambiguous name or path for the desired database. If you would rather 
        manually input the full path to a trace database not found by this program, 
        use the -p or --path option instead.

EOE

    opts = OptionParser.new do |opts|
      opts.banner = "           Usage: ruby \#{program_name} [options]"
      opts.separator ""
      opts.separator ""
      opts.separator "Specific options:"
      opts.separator ""

      # Keyword completion.  We are specifying a specific set of arguments (dbase_list
      # and short_names - notice the latter is a Hash), and the user may provide
      # the shortest unambiguous text.
      dbase_ops = (short_names.keys + dbase_list).join(', ')
      opts.on("-d", "--database PATH", dbase_list, short_names, "Select database",
              "(Type the desired database name from the list below,",
              "either the short name or the full path works.)",
              "   (\#{dbase_ops})") do |db|
        raise OptionParser::ParseError, "\#{db} is not a valid argument. Type -h for more information" if /^-/ =~ db
        options.db_path = db
      end

      #the other option for inputing the path to a database you want to use in your
      #search
      opts.on("-p", "--path PATH", "Give the full PATH of the database",
      "(Use this flag if -d or --database doesn't find your DB)") do |path|
        raise OptionParser::ParseError, "\#{path} is not a valid argument. Type -h for more information" if /^-/ =~ path
        raise OptionParser::ParseError, "\#{path} is not a valid argument. Type -h for more information" if !(/^\\// =~ path)
        path = path.gsub(/(\\.\\d*\\.nin)|(\\.nin)/, '')
        options.db_path = path
      end

      #enter the input filename
      opts.on("-f", "--file NAME", "search with the fasta sequence in file NAME",
              "(file has to be in same folder as this program)") do |name|
        raise OptionParser::ParseError, "\#{name} is not a valid argument. Type -h for more information" if /^-/ =~ name
        options.infile = name
      end      


      opts.on("-a", "--append NAME", "If you want to specify the folder suffix that this",
                                      "run places its results into, provide the NAME",
                                      "(Default suffix is current date & time)") do |apnd|
        options.append = apnd                               
      end


      #set the number of CPU's, defaults to 1
      opts.on("-c", "--cpu NUMBER", Integer, "Run program on NUMBER of CPU's, default is #{ins_options.cpu}") do |num|
        #raise OptionParser::ParseError, "\#{num} is not a valid argument. Type -h for more information" if /^-/ =~ num
        #raise OptionParser::ParseError, "\#{num} is not a valid integer argument. Type -h for more information" if (/[^\\d]/ =~ num)
        options.cpu = num
      end


      opts.on("-i", "--initial_eval EVAL", "Enter the EVAL to run the initial blast search,",
              " the default value is 1") do |i_eval|
        options.initial_eval = i_eval
      end

      opts.on("-r", "--reciprocal_eval EVAL", "Enter the EVAL to run the reciprocal blast search,",
              " the default value is 1e-40") do |r_eval|
        options.recip_eval = r_eval
      end



      opts.on("-m", "--max_hits NUMBER", Integer, 
      "Give the maximum NUMBER of blast hits, default is #{ins_options.max_blast}" ) do |num_hits|
        #raise OptionParser::ParseError, "\#{num_hits} is not a valid argument. Type -h for more information" if /^-/ =~ num_hits
        #raise OptionParser::ParseError, "\#{num_hits} is not a valid integer argument. Type -h for more information" if (/[^\\d]/ =~ num_hits)
        options.max_blast = num_hits
      end


      #turn the low complexity filter on
      opts.on("-l", "--low", "Turn on Blast's query seq filter, default is off") do
        options.blast_filter = 'T'
      end

      opts.on("-C", "--composition_scoring", "Turn off blast's composition based scoring",
              " default is on") do
        options.blast_comp_scoring = 'F'
      end






      # Boolean switch.
      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        options.verbose = v
      end

      # Boolean switch.
      opts.on("--[no-]debug", "Run with debug output") do |v|
        options.debug = v
      end

      # No argument, shows at tail.  This will print an options summary.
      # Try it and see!
      opts.on_tail("-w", "--welcome", "Show welcome mesage with setup instructions") do
        print "\\n", welcome
        exit 1
      end


      # No argument, shows at tail.  This will print an options summary.
      # Try it and see!
      opts.on_tail("-h", "--help", "Show this message") do
        print "\\n", welcome2
        puts opts
        print "\\n", explanation
        exit 1
      end

      # Another typical switch to print the version.
      opts.on_tail("--version", "Show version of \#{program_name}") do
        puts version
        exit
      end

    end #opts.OptionParser

    opts.parse!(args)
    raise OptionParser::ParseError, "Missing required arguments." if  (options.db_path == '' || options.infile == '')
    return options
  rescue OptionParser::ParseError => e
    puts ""
    puts e
    puts ""
    puts ""
    opts.parse(["-h"])
  end #self.parse(args)
end #class




############TblastN class definition###################################################

def TblastN(inseq, db, cpu_count, max_blast_hits, initial_eval, blast_seq_filter, comp_scoring, verbose, debug)

  if debug
    puts "entering TblastN"
  end

  ####Run the Protein vs. Trace DNA BLAST search########################################
  # This line runs the blast by sending a command to the shell.  This command
  # is first echoing the input sequence, and piping this to the blastall command

  # Blastall: (given on the command line by blastall --help)
  # Required Arugments:
  # -d argument (to set the path to the database)
  # -p (program), which specifies the program to be used
  # Optional Arguments:
  # -m alignment view/output (-m) to 8, which gives us tabular format
  # -b number of database sequences to show alignments for 
  # -e  Expectation value (E) [Real]  default = 10.0  

  hits = `echo \#{inseq} | blastall -d \#{db} -p tblastn -m 8 -a \#{cpu_count} -b \#{max_blast_hits}\\\\
   -v \#{max_blast_hits} -e \#{initial_eval} -F \#{blast_seq_filter} -C \#{comp_scoring}`
  hit_number = 0

  #the output from this file will be multiple lines as follows
  #fields 
  #Query id,Subject id,% identity,alignment length,mismatches,gap openings,q. 
  #start,q. end,s. start,s. end,e-value,bit score
  #actual results
  #tmpseq_0     gnl|ti|1867886320       100.00  48      0       0       1      48       499     642     1e-23    112

  # From these results, we essentially want to save the Subject ID (the second column), 
  # and get the nucleotide FASTA sequence from the same database using the fastacmd 
  # program

  #  At this point, we set two new arrays to get to the output we want
  # ids: which stores the id line from the blast results
  # and fastas: which stores the fasta sequences from the hits

  ids = Array.new()
  fastas = Array.new()

  #########PARSE RESULTS FOR SUBJECT ID/GET CORRESPONDING FATSA SEQUENCES###########
  # To parse the results, we are taking each line from the blast report, 
  # For each line, we split the line at tab character into a new array (f)  
  # As Subject ID is in the second column, we can take this column f[1] and push 
  # it onto the end of the ids array.  
  # We can then get the sequence for this id using the fastacmd sequence, and 
  # Fastacmd parameters (again, you can access using fastacmd --help
  # -d database (as above)
  # -s search string (which we are feeding in the subject ID)
  # the output will be a fasta sequence e.g.
  # >gnl|ti|1717356516 233598775
  #TAATGGTAAAAGTAGTTCATCATGTGCCTCATACCTGGTTCGGCGATGATACCATTTTTCTCCATTATA....

  hits.each do |f|
    hit_number += 1
    x = f.split(/\\t/)
    ids.push(x[1])
    fasta_seq = `fastacmd -d \#{db} -s '\#{x[1]}'`  # might be good to catch exception
    fastas.push(fasta_seq)
  end
  if verbose 
    puts "found \#{hit_number} hits"
  end

  # Now, for testing purposes, we are printing out these subject ID, folllowed by the 
  # FASTA seqeunce, for each of these results... 

  ids.length.times do |i|
    if verbose
      puts ids[i]
      puts fastas[i]
    end
  end

  if debug
    puts "leaving TblastN"
  end

  return ids, fastas
end


#########****DEFINE NEW FUNCTION find_db()******###########################
#for now this function is depricated

=begin
def find_db() 


  #  s = `locate *\#{name}*\\.nin`
  s = `find /research -name *nin`
  s = s.split(/\\n/)

  puts ""
  s.each_with_index do |obj,i|
    print i, ") ", obj, "\\n"
  end

  puts ""
  print "Input the number of one desired tracefile: "
  choice = gets
  puts ""
  db = s[choice.to_i]
  db = db.gsub(/(\\.\\d*\\.nin)|(\\.nin)/, '') #takes off either .digit.nin or just .nin endings
  #if we need to remove digit.nin without a preceeding . then we need to rething this regex
  return db

end
=end



################
# 2d array printing method
# => for verbose output and debugging
###############
def print_2d(arr, debug)
  if debug
    puts "entering print_2d"
  end
  i = arr.length
  i = i - 1
  0.upto(i){ |x|
    if arr[x] == nil
      puts arr[x]
    else
      arr[x].each{ |y|
        print y.to_s
        print " "
      }
      puts
    end
  }
  if debug
    puts "leaving print_2d"
  end

end




#########****DEFINE NEW FUNCTION cluster_redundant()******###########################
#
def cluster_redundant(ids, fastas, db, outFileName, evalCut, cpu_count, verbose, debug)
  if debug
    puts "entering cluster_redundant"
  end

  #myFile = File.new(outFileName,  "w+")
  id_in_contig = Hash.new(Array.new()) #Add things to a result string only if they don't exist in this hash
  fa = 0
  linked_to = Array.new(Array.new())

  ufn = Array.new()

  #go through results and blastn them back to the traceDB adding one occurence of each
  #hit of greater value that the eval cutoff to the output file.
  #for each result not found, you would like to make 
  ids.each_with_index do |obj,i|
    if id_in_contig[obj].empty?
      cfn = "\#{outFileName}\#{fa}" #current file name; a
      myFile = File.new(cfn, "w+")
      ufn.push(cfn)
      #########*******THOMAS_TODO 
      # push each myFile name into the unique_hit_filenames array

      sequence = fastas[i].gsub(/\\>.*\\n/, '')
      sequence = sequence.gsub(/\\n/, '') #remove newlines from sequence
      results = `echo \#{sequence} | blastall -d \#{db} -a \#{cpu_count} -p blastn -m 8 -e \#{evalCut}`
      results = results.split(/\\n/)
      #fa = fa.next  #changes the appended letter for the next file name
      results.each do |r|
        x = r.split(/\\t/)
        if id_in_contig[x[1]].empty?
          if verbose
            puts "in first if statement, fa = \#{fa} id_in_contig = \#{ id_in_contig[x[1]]}"
          end
          id_in_contig[x[1]] = [fa]
          myFile.puts(`fastacmd -d \#{db} -s '\#{x[1]}'`)
        elsif id_in_contig[x[1]] == [fa]
          if verbose
            puts "duplicate seqeunce: \#{fa} = \#{id_in_contig[x[1]]}" 
          end
        else
          if verbose
            puts "sequence \#{x[1]} already in contig \#{id_in_contig[x[1]]}."
            puts "fa = \#{fa} id_in_contig = \#{id_in_contig[x[1]]}"
          end
          if !linked_to[fa] 
             linked_to[fa] = [] 
           end
          linked_to[fa] |= id_in_contig[x[1]]
          id_in_contig[x[1]] |= [fa]
          if verbose
            puts "fa = \#{fa} id_in_contig \#{x[1]} = \#{id_in_contig[x[1]]}"
          end

          myFile.puts(`fastacmd -d \#{db} -s '\#{x[1]}'`)
        end
      end
      fa = fa.next 
      myFile.close
    end
  end
  if debug
    puts "leaving cluster_redundant"
  end 

  return ufn, linked_to
end





###################
## Merge the duplicates
###################
def merge_if_duplicates(linked_to, outFileName, ufn, verbose, debug)
  merge_ufn = []
  if debug
    puts "entering merge_if_duplicates"
  end

  i = linked_to.length
  if verbose
    puts "length of array is \#{linked_to.length}"
  end
  i = i - 1 # the length is one more than the index

  i.downto(0) { |n|
    if linked_to[n]
        linked_to[n].each{ |t|
          if !linked_to[t]
            linked_to[t] = []
          end
          linked_to[t] |= linked_to[n]
        } # prepair the arrays for complete merging
        linked_to[n].each { |x|
        if linked_to[x]
          linked_to[n] |= linked_to[x]
          linked_to[n].each { |y|
            if linked_to[y]
              linked_to[n] |= linked_to[y]
              if y != n
                linked_to[y] = nil
              end
            end
          }
        end
        }
        if linked_to[n] 
          linked_to[n] |= [] #remove any duplicates
          linked_to[n] = linked_to[n].sort #sort the array
          linked_to[n].delete(n) #delete any instances of self
         end

    end
  }

  i.downto(0) { |n|
    if verbose
      puts "n = \#{n}"
      puts "looking for contigs to merge"
      print_2d(linked_to, debug)
    end

    if linked_to[n]
        if verbose
          puts "found contig which needs to be merged"
        end
        result = ""
        outname = outFileName
        linked_to[n].each { |x|
          result = result + " " + outFileName + x.to_s
          outname = outname + x.to_s + "+"
        }
        result = result + " " + outFileName + n.to_s
        if verbose
          puts "result is \#{result}"
        end
        outname = outname + n.to_s
        if verbose
          puts "cat \#{result} > \#{outname}"
        end
        junk = `cat \#{result} > \#{outname}`
        merge_ufn.push(outname)
    end
  }

  if debug
    puts "leaving merge_if_duplicates"
  end
  return merge_ufn
end


#########****DEFINE NEW FUNCTION assemble_contigs()******###########################

def assemble_contigs(ufn, cpu_count, verbose, debug)
  if debug
    puts "entering assemble_contigs"
  end
  ########
  # first find out whether cpu_count is greater or less than ufn
  # assign the lesser of the two values to cpu_num
  cpu_num = 1
  if ufn.length > cpu_count
    cpu_num = cpu_count
  else
    cpu_num = ufn.length
  end
  ########
  i = 0

  while i < ufn.length
    threads = []
    for n in 1..cpu_num do
      break if i == ufn.length
      threads << Thread.new(ufn[i]) { |my_ufn|
        if verbose
          puts
          puts "cap3 \#{my_ufn}"
        end
        junk = `cap3 \#{my_ufn}` 
      }
      i = i + 1
    end
    threads.each { |aThread| aThread.join }
  end
  if debug
    puts "leaving assemble_contigs"
  end

end

#########****DEFINE NEW FUNCTION contig_parser()******###########################
#
def contig_parser(name, inseq, outFileName, verbose, debug)

  if debug
    puts "entering contig_parser"
  end

  id=Array.new(0)
  seq=Array.new(0)
  j=0
  i=0
  contig=Hash.new(0)

# Make a new file for the input sequence (inseqfile.aa) for use in bl2seq

  inseqfile = File.open(inseq)
  #basename = outFileName
  basename = name.split('.')[0]

# open the contig sequence file, push it onto the seq array

  File.open(name).each do |x|
    seq.push(x)
  end

# break the contig file into a Hash called contig; 
# Everytime you find a FASTA defline (marked by the > character)
# put that into a array of ids
# Then get the sequence for each of these lines, and push onto a array called seqline
# These are then combined into an the has called contig, where


  while i< seq.length
    if seq[i].to_s =~/>/
      id.push(seq[i])
    end 
    i=i+1 
    seqline=Array.new
    while !(seq[i].to_s=~/>/)   
      break if i >= seq.length 
      seqline<<seq[i]
      i=i+1
    end

    s=String.new
    s=id[j]
    contig[s]=seqline 
    j=j+1
  end

  if verbose
    puts "\#{id.length} contigs identified"
  end

# if only 1 contig in file, then no need to look for more
  #b2a_filename = outFileName.chop
  #b2a_filename = b2a_filename + ".contigs"

  if id.length == 0  
    #puts "only one seqeunce"
    newfilename = "\#{basename}.single"
    #puts "basename = \#{basename}"
    seq_name = "\#{basename}.cap.singlets"
    File.copy(seq_name, newfilename)
    if debug
      puts "in case id.length == 0"
      puts "contig_parser sending \#{newfilename} to bl2out_format"
    end
    bl2out_format(newfilename, inseq, verbose, debug)
    if debug
      puts "back to contig_parser from bl2out_format"
    end

  elsif id.length == 1   
    if verbose
      puts "only one contig"
    end
    newfilename = "\#{basename}.single"
    File.copy(name, newfilename)
    if debug
      puts "in case id.length == 1"
      puts "contig_parser sending \#{newfilename} to bl2out_format"
    end
    bl2out_format(newfilename, inseq, verbose, debug)
    if debug
      puts "back to contig_parser from bl2out_format"
    end


### if more then 1 contig FASTA sequence, you will need to find the best contig  

  else    

    evalue = 40
    min = 1 
    bestfilename = "\#{basename}.single"

    # Make a file for current contig the best_contig      
    newfilename="temp_bestcontig.fa"

    id.each do |j| 
      newfile = File.new(newfilename,"w+")
      newfile.puts("\#{j}","\#{contig[j]}")
      newfile.close()

      # Now need to set up a blast to see what is the best contig in these files
      hit = `bl2seq -i temp_bestcontig.fa -j \#{inseq} -p blastx -D 1`

      hit.each do |x|  
        if !(x.to_s =~ /#/)          
          f=x.split(/\\s+/)
          evalue = f[10].to_f
          if min > evalue
            min = evalue
            File.rename(newfilename, bestfilename)
          end
        end
       end
    end
    if debug
      puts "in case id.length > 1(last else statement in contig_parser)"
      puts "contig_parser sending \#{bestfilename} to bl2out_format"
    end
    bl2out_format(bestfilename, inseq, verbose, debug)
    if debug
      puts "back to contig_parser from bl2out_format"
    end
  end
  if debug
    puts "leaving congtig_parser"
  end
end



#########****DEFINE NEW FUNCTION bl2out()******###########################
#performs bl2out for a query and insert sequence, and produces a 
#formatted page showing all aligmnents and scores above an minium e-value
#Also gives translation in the frame of these alignments...

def bl2out_format(qseq, inseq, verbose, debug)
  if debug
    puts "entering bl2out_format"
  end

  min_expect = 1
  i = 0      

  if verbose
    puts "now blasting query: \#{qseq} against inseq: \#{inseq}"
  end

  basename = qseq.to_s.split('.')[0]
  b2o_filename = "\#{basename}.b2o"
  b2out = File.new(b2o_filename,"w+")
  b2out.puts ">\#{qseq} best contig"

  br = Array.new
  frames = Array.new

  blastreport = `bl2seq -i \#{qseq} -j \#{inseq} -p blastx`

  br = blastreport.split(/\\n/)
  while i < br.length 

    if !(br[i].to_s =~ /Expect/)
      i = i+1
    else
      expect=br[i].split('Expect')
      expect_val=expect[1].split(' = ')

      if !(expect_val[1].to_f < min_expect)
        i = i+1
      else
        b2out.puts br[i] 
        i = i+1
        b2out.puts  br[i]
        i = i+1
        frame = br[i].split(' = ')
        frame_val = frame[1].to_i
        if !frames.include?(frame_val)
          frames << frame_val
        end

        while (i < br.length and !(br[i].to_s =~ /Score/) and !(br[i].to_s =~ /Lambda/) )                           
          b2out.puts  br[i]
          i = i+1

        end
      end
    end

  end

  s = Bio::Sequence::NA.new((Bio::FastaFormat.new(File.open(qseq).read)).seq)
  frames.each do |e| 
    b2out.puts "\#{qseq} translation Frame " + e.to_s
    b2out.puts s.translate(e) 
  end
  b2out.puts
  b2out.close

  if debug
    puts "leaving bl2out_format"
  end

end


#########****DEFINE NEW FUNCTION find_best_contig()******###########################


def find_best_contig(ufn, inseq, outFileName, verbose, debug)
  if debug
    puts "entering find_best_contig"
  end

  ufn.each { |e|  
    if verbose
      puts "finding best contig for \#{e}"
    end
    contigsfile = e + '.cap.contigs'

    if debug
      puts "find_best_contig is sending \#{contigsfile} to contig_parser"
    end
    contig_parser(contigsfile, inseq, outFileName, verbose, debug)
    if debug
      puts "back to find_best_contig from contig_parser"
    end
  }

  if verbose
    puts "best contigs identified"
  end
  if debug
    puts "leaving find_best_contig"
  end

end


######################Program Control##################################


begin
  #Get starting time of the program
  time = DateTime.now
  sec = time.sec.to_s
  min = time.min.to_s
  hour = time.hour.to_s
  month = time.month.to_s
  day = time.day.to_s
  year = time.year.to_s



  options = CommandLineArgs.parse(ARGV, time)

  append = options.append
  blast_seq_filter = options.blast_filter
  cpu_count = options.cpu
  infasta = String.new()
  infastafile = options.infile
  init_evalCut = options.initial_eval
  evalCut = options.recip_eval
  verbose = options.verbose
  debug = options.debug
  max_blast_hits = options.max_blast
  comp_scoring = options.blast_comp_scoring
  f = File.open(infastafile, "r")
  f.each_line do |line|
    infasta = infasta + line
  end


  defline = infasta[/.*/].sub(/^>/, '').strip
  sequence = infasta.sub(/.*/, '')                 
  sequence.sub!(/^>.*/m, '')
  inseq = sequence.gsub(/\\n./, '').rstrip + '\\n'
  outFileName = defline.split(/\\s./)[0]
  outFileName = outFileName + "_"

  db = options.db_path
  dbbasename = db.split("/")[-1]
  dbbasename = dbbasename.split('.')[0]


  dbbasename = dbbasename + '_' + append

  if verbose
    puts dbbasename
  end

  if !(File.exist?(dbbasename))
    Dir.mkdir(dbbasename)
  elsif !(File.directory?(dbbasename))
    raise "File \#{dbbasename} is not a directory, please rename \#{dbbasename} and run program again."
  end
  if !(File.exist?("\#{dbbasename}/\#{outFileName}work"))
    Dir.mkdir("\#{dbbasename}/\#{outFileName}work")
  end
  if !(File.exist?("\#{dbbasename}/\#{outFileName}results"))
    Dir.mkdir("\#{dbbasename}/\#{outFileName}results")
  end
  File.copy(infastafile, "\#{dbbasename}/\#{outFileName}work/\#{infastafile}")
  Dir.chdir("\#{dbbasename}/\#{outFileName}work")
  if debug
    puts File.exist?("\#{dbbasename}/\#{outFileName}work/\#{infastafile}")
  end



  param_sum = File.new("../\#{outFileName}results/input_params.log","w+")
  param_sum.puts "Begin job: \#{dbbasename} at \#{hour}:\#{min}:\#{sec} on \#{month}/\#{day}/\#{year}" 
  param_sum.puts "Input: \#{defline}" 
  param_sum.puts "Ran on \#{cpu_count.to_s} processors" if cpu_count > 1
  param_sum.puts "Ran on \#{cpu_count.to_s} processor" if cpu_count == 1
  param_sum.puts ""
  param_sum.puts "Initial blast search ran with eval cutoff: \#{init_evalCut}"
  param_sum.puts "Initial blast search ran with filter: \#{blast_seq_filter}"
  param_sum.puts "Initial blast search ran with composition based scoring: \#{comp_scoring}"
  param_sum.puts "Initial blast search ran with a limit of \#{max_blast_hits} hits"
  param_sum.puts ""
  param_sum.puts "Reciprocal blast search ran with eval cutoff: \#{evalCut}"
  param_sum.puts "" if (verbose || debug)
  param_sum.puts "Ran with verbose output" if verbose
  param_sum.puts "Ran with debug output" if debug
  param_sum.puts ""
  param_sum.close

  if debug
    puts "input: \#{defline} " 
    puts "files saving with prefix \#{outFileName}"
    puts inseq
  end

  ids, fastas = TblastN(inseq, db, cpu_count, max_blast_hits, init_evalCut, blast_seq_filter, comp_scoring, verbose, debug)
  ufn = Array.new()
  merge_ufn = Array.new()
  linked_to = Array.new()

  ufn, linked_to = cluster_redundant(ids, fastas, db, outFileName, evalCut, cpu_count, verbose, debug)
  merge_ufn = merge_if_duplicates(linked_to, outFileName, ufn, verbose, debug)


  assemble_contigs(ufn, cpu_count, verbose, debug)
  find_best_contig(ufn, infastafile, outFileName, verbose, debug)
  b2afn = outFileName.chop #remove the '_' character at the end of the outFileName
  if verbose
    puts "cat \#{outFileName}*.b2o > ../\#{outFileName}results/\#{b2afn}.b2a"
  end
  junk = `cat \#{outFileName}*.b2o > ../\#{outFileName}results/\#{b2afn}.b2a`

  assemble_contigs(merge_ufn, cpu_count, verbose, debug)
  find_best_contig(merge_ufn, infastafile, outFileName, verbose, debug)
  if verbose
    puts "cat \#{outFileName}*+*.b2o >> ../\#{outFileName}results/\#{b2afn}.b2a"
  end
  junk = `cat \#{outFileName}*+*.b2o >> ../\#{outFileName}results/\#{b2afn}.b2a`


  param_sum = File.open("../\#{outfileName}results/input_params.log","a")
  time = DateTime.now
  param_sum.puts "Job ended at: \#{time.hour.to_s}:\#{time.min.to_s}:\#{time.sec.to_s} on \#{time.month.to_s}/\#{time.day.to_s}"
  param_sum.puts ""
  param_sum.close

  if debug
    puts ""
    puts "---------------------------------------"
    puts "-=::Gene Family Finder run complete::=-"
    puts "---------------------------------------"
    puts ""
  end

  #error handling
rescue Exception => msg
  puts "\#{$0}: \#{msg}"
end



TILLTHEEND
  f.close
  
  `chmod 755 #{ins_options.path}/#{ins_options.program_name}`
  
#error handling
rescue Exception => msg
  puts "#{$0}: #{msg}"
end