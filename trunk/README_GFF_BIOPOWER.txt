###########################################
##  Using Gene Family Finder on Biopower ##
###########################################

The program takes a fasta file with the amino acid sequence of the gene you are interested in characterizing, and the trace database you are interested in finding the gene in, and gives you a file that summarizes potential exons of closely related genes. 

#########################
Step by step walkthrough:
#########################
Short Version:

1. Make a new working directory in Biopower
2. copy the gff program into the new directory
3. 





Expanded Version:

KEY:
I will be using [] and {} in various places through out this walkthrough. [] always means replace what is inside the brackets. {} always means press that key on your keyboard.
	Example:
	[your word] means type your personal word there. 
	{ENTER} means press the ENTER key on your keyboard.
	

1. Login to biopower
 		type:	ssh [username]@biopower.uoregon.edu {ENTER}
		in a "terminal" window on any non-Microsoft computer.
			**If you are on a Windows computer, there are some free SSH clients you can download, after logging into biopower the rest of the steps are the same.
	
2. Make a new folder to work in.
		type:	mkdir [work foler name] {ENTER}

3. Go into your new work folder
		type cd [work folder name] {ENTER}

4. Make a new file with a descriptive name ending in '.fa' to store the
 	fasta sequence you use to search against the trace database. A good 
	name for the file of the upcomming example would probably be 
	"DRerioGATA3homolog.fa" Make sure that the first line of the file is 
	the fasta definition line and the next lines contain the amino acid 
	sequence followed by nothing else. Here is an example of acceptable 
	contents for one of these files:
	
>gi|1245717|gb|AAA93491.1| transcription factor; GATA 3 homolog [Danio rerio]
MEVSPEQHRWVTHHTVGQHPETHHPGLGHSYMDPSQYQLAEDVDVLFNIDGQSNHPYYGNPVRAVQRYPP
PPHSSQMCRPSLLHGSLPWLDGGKSIGPHHSTSPWNLGPFPKTSLHHSSPGPLSVYPPASSSSLSAGHSS
PHLFTFPPTPPKDVSPDPAISTSGSGSSVRQEDKECIKYQVSLAESMKLDSAHSRSMASIGAGASSAHHP
IATYPSYVPDYGPGLFPPSSLIGGSSSSYGSKTRPKTRSSSEGRECVNCGATSTPLWRRDGTGHYLCNAC
GLYHKMNGQNRPLIKPKRRLSAARRAGTSCANCQTTTTTLWRRNANGDPVCNACGLYYKLHNINRPLTMK
KEGIQTRNRKMSSKSKKSKKSHDSMEDFSKSLMEKNSSFSPAALSRHMTSFPPFSHSGHMLTTPTPMHPS
SSLPFASHHPSSMVTAMG

	The above example was simply copied from NCBI. I found the protein
	I was looking for and selected 'FASTA' from the "Display" drop down
	menu near the top of the screen.



5. Using an ftp client like fugu (http://rsug.itd.umich.edu/software/fugu/)
	to place the file containing the amino acid fasta sequence that you wish to
	search with into the work folder you created in step 2.

6. Decide which organism you would like to search with the protein sequence you
	just added to your work folder. 

7. Go back to your terminal window where you are logged into biopower.uoregon.edu
 	with ssh. If you are no longer logged in repeat steps 1 and 3.
	Type: gff --help {ENTER}

8. Scroll up and look through the list after the description of --database.
	This list shows all of the trace database names that the program was able to
	find, followed by the full paths to the databases. Find the organism you want 
	to search in this list and make sure you remember exactly how it is spelled 
	(case sensitive).
	
	(You either need to remember just the name of the organism or the full 
	path to the organism, but not both. The only time you would want to know 
	the full path rather than just the name, is if there are multiple versions 
	of an organism's trace database in your computer and you want to be sure 
	to search the latest version. Consult with the biopower administrator if 
	you are worried this might be a problem.
	
9. For standard operation of the gene family finder program, assuming I was using
	a file named NvGATA.fa to search with and I wanted to search against the
	danio_rerio database, I could type the following to start a run:
	
	gff -f NvGATA.fa -d danio -c 8 {ENTER}
	
	Notice that I only had to type in the first part of danio_rerio. As long as you
	type the shortest unambiguous name for the organism you want to search, the
	program will work. If however there are two organisms in the list who's names
	begin with "danio" than the program will arbitrarily choose one of them. Make 
	sure to type a long enough name from the list that the program will know which
	organism you want it to search.
	
	In the above example I typed -c 8. This sets the number of processors to split
	the job between to 8 (there are 8 processors on biopower). You do not have to 
	type this in, it will default to 1 processor, however it will run slower if you
	do not take full advantage of the computing power available.
	
9. Thats it! The program may take quite a long time to complete. For example our
	analysis of danio_rerio took 8 hours on biopower. Smaller trace archives take
	much less time. oikopleura_dioica only takes about 5 minutes on 8 processors.
	
10. After the program is complete, open the folder that is the name of the database 
	you searched followed by a date-stamp of the time you started the search. Using 
	the ftp client (fugu) open up that folder. Inside that folder you will see two
	folders: [fasta name]_work and [fasta name]_results. Open the results folder and
	drag the [fasta name].b2a file to your desktop. This file contains the program's 
	output.
	
11. Open the [fasta name].b2a file with your favorite text editor and begin your
	analysis of the results.


		