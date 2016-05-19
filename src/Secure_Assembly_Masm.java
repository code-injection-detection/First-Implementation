import java.util.*;
import java.io.*;
/*
 * This is the MASM32 version of the Secure_Assembly java program
 * This program takes as input (has hardcoded name of file in it). The file
 * is a .asm / assembly file hence, it is in text format.
 * It inserts nop instructions (which will be replaced with keyshares) between
 * instructions. 
 * It does this by some not-very-clean parsing, (but we could refine it later)
 * (The point is that parsing an assembly file is still way easier than parsing
 * a C file.)
 * To handle the jumps over the instructions, we add labels. 
 */
public class Secure_Assembly_Masm2 {
	
	public static void main(String[] args) throws Exception
	{
		String filename = "C:/masm32/codesec.asm";
		Scanner sc = new Scanner(new File(filename));
		ArrayList<String> list = new ArrayList<String>();
		sc.useDelimiter("\n");
		String ulabel = "unique";
		int n= 3;
		int counter = 0;
		int i = 0;
		int  k = 1;
		
		// This puts the file into the ArrayList and looks for the start of the code
		// which is ".code"
		
		while (sc.hasNext())
		{
			String line = sc.next();
			line = removeNewlines(line);
			list.add(line);
			if (removeSpaces(line).indexOf(".code")!=-1)
			{
				break;
			}			
			
		}
		
		// Adding these NOPs help identify the beginning of code for the Secure_Machine_code program
		list.add("NOP");
		list.add("NOP");
		
		// This inserts the jumps and NOPs in the code.
		// It breaks at the end of the code ("end")
		while(sc.hasNext())
		{
			String line = sc.next();
			line = removeNewlines(line);
			if (removeSpaces(line) == "")
			{
				continue;
			}
			if (removeSpaces(line).startsWith("end") && !(sc.hasNext()))
			{

				
				list.add("jmp end_of_program_label");
				
				// We force the end of file canary
				// to be followed by as many nops as the number of keyshares
				// to ease identification of the end of code
				for(int m=0;m<k+2;m++)	
				{   	                
					list.add("nop");    
				}
				
				
				list.add("end_of_program_label: nop");
				list.add(line);
				break;
			}
			
			// After skipping n instructions, we put in the key share
			if (i == n)
			{
				list.add(" jmp " + ulabel + counter);
				for (int j = 0; j < k+1; j++)
					list.add("NOP");
				
				list.add(ulabel + counter + ": nop");
				list.add(line);

				i = 0;
				counter++;
				continue;
			}
			
			i++;
			list.add(line);
			//System.out.println(line);
		}
		
		
		for (String s: list)
		{
			System.out.println(s);
		}
		
		
		
		// This write the modified lines into a new ASM
		// You can use MASM to assemble this ASM into machine code
		String finalfile = "";
		String newfilename = filename.substring(0,filename.length()-4) + "_sec.asm";
		System.out.println(newfilename);
		BufferedWriter bw = new BufferedWriter(new FileWriter(newfilename));
		for (String line: list)
		{
			bw.write(line);
			bw.newLine();
		}
		
		bw.write(finalfile);
		bw.flush();
        sc.close();
        bw.close();
		
	}
	
	// Removes spaces as well as changing the each character to lower case
	// For comparing functions
	static String removeSpaces(String abc)
	{
		String line = "";
		for(int i=0;i<abc.length();i++)
		{
			if(abc.charAt(i) == ' ' || abc.charAt(i)=='\t' || abc.charAt(i) == '\n' || abc.charAt(i) == '\r')
			{
				
			}
			else
			{
				line = line+(abc.charAt(i)+"").toLowerCase();
			}
		}
		
		return line;
	}
	static String removeNewlines(String s)
	{
		String line = "";
		for (int i = 0; i < s.length(); i++)
		{
			if (s.charAt(i) != '\r' && s.charAt(i) != '\n')
				line += s.charAt(i);
		}
		return line;
	}

}
