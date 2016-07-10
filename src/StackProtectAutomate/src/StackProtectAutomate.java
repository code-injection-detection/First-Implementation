import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
public class StackProtectAutomate {
	public static void main(String[] args) {
		
		Path testpath = Paths.get("C:\\Users\\Yun\\workspace\\StackProtectAutomate\\src\\masmparsetest.asm");
		List<String> lines;
		try {
			lines = Files.readAllLines(testpath);
		} catch (IOException e) {
			System.err.println("Couldn't read file");
			return;
		}
		System.out.println("-------------ORIGINAL FILE-------------");
		for (String l : lines)
			System.out.println(l);
		System.out.println("-------------END ORIGINAL FILE-------------");
		
		PrintWriter outputfile;
		try {
			outputfile = new PrintWriter("C:\\Users\\Yun\\workspace\\StackProtectAutomate\\src\\parseoutput.asm", "UTF-8");
		} catch (FileNotFoundException | UnsupportedEncodingException e) {
			System.err.println("Can't create new file");
			return;
		}

		// A bunch of crazy variables
		String type = "N/A"; 		// mov, push, pop, call, ret
		String movetype = "N/A"; 	// mov, movsx, movzx
		String reg = "N/A";			// eg. mov ecx, dword ptr [ebp+12] ==> reg == ecx
								    // eg. mov dword ptr [ebp+12], ecx ==> reg == ecx
		String stackreg = "N/A";	// above examples ==> stackreg == ebp
									// NOTE: stackreg does not have to be a register
									//       since we always do "mov esi, STACKREG"
									//       when asking offsetcalc to calculate the addr for us
		String stackaddr = "N/A";	// above examples ==> stackaddr == ebp+12
		String stackoffset = "N/A"; // above examples ==> stackoffset == 12
		boolean isReg2stack = false;// true if data moves from register to stack
		String wordsize = "N/A";    // dword, word, byte (used in context of "mov dword ptr ...", etc.
		int geteipnum = 0;			// we need a different label each time we use the get eip trick
		
		for (int i = 0; i < lines.size(); i++)
		{
			System.out.println("");
			System.out.println(lines.get(i));
			// Get the line& remove spaces&comments for easy handling
			String s = removeSpaces(lines.get(i));
			
			
			if ( s.isEmpty()
			 ||
				 (
					  !(s.contains("[")
					 && s.contains("]")
					 && s.contains("ptr")
					   )
				 
				 && !s.startsWith("push")
				 && !s.startsWith("pop")
				 && !s.startsWith("call")
				 && !s.equals("ret")
				 )
			 )
			{

				outputfile.println(lines.get(i));
				continue;
			}
			System.out.println("Line sans comments/spaces: " + s);
			

			
			// mov
			// First handle lines like "mov ecx, dword ptr [ebp+12]" 
			// In this example: 
			// reg == "ecx"
			// stackreg == "ebp"
			// stackaddr == "dwordptr[ebp+12]"
			// stackoffset == 12 (positive 12)
			// isReg2stack == false
			// wordsize == dword
			if (s.startsWith("mov"))
			{
				type = "mov";
				s = s.substring(3);
				
				// if start with sx, then we had movsx-- remove the sx
				// this is no problem because movsx moves things INTO register,
				// and no register starts with "sx"
				if (s.startsWith("sx"))
				{
					s = s.substring(2);
					movetype = "movsx";
				}
				else if (s.startsWith("zx"))
				{
					s = s.substring(2);
					movetype = "movzx";
				}
				else
				{
					movetype = "mov";
				}	
				
				
				// Check the wordsize (can only handle dword = 4 and byte = 1
				if (s.contains("dwordptr["))
				{
					wordsize = "dword";
				}
				else if (s.contains("byteptr["))
				{
					wordsize = "byte";
				}
				else if (s.contains("wordptr["))
				{
					wordsize = "word";
				}
				else 
				{
					wordsize = "N/A"; // ehhhhhhh can't handle any other size yet
				}
				
				
				// Separate the 2 arguments to the mov
				// One before the comma (dest), one after (src)		
				List<String> destsrc = Arrays.asList(s.split(","));
				
				System.out.println("Dest = " + destsrc.get(0));
				System.out.println("Src = " + destsrc.get(1));
		
				// destsrc.get(0) is the dest, destsrc.get(1) is the src
				if (destsrc.get(0).contains("[") && destsrc.get(0).contains("]"))
				{
					isReg2stack = true;
				}
				else
				{
					isReg2stack = false;
				}
				
				// Get the register (the one NOT used for the stack base addr)
				if (isReg2stack)
				{
					reg = destsrc.get(1);
				}
				else
				{
					reg = destsrc.get(0);
				}
				
				// Get the String inside the brackets [ ... ]
				if (isReg2stack)
				{
					stackaddr = destsrc.get(0).substring(destsrc.get(0).indexOf('[')+1, destsrc.get(0).indexOf(']'));
				}
				else
				{
					stackaddr = destsrc.get(1).substring(destsrc.get(1).indexOf('[')+1, destsrc.get(1).indexOf(']'));
				}
				//System.out.println("stackaddr = " + stackaddr);
				
				// we handle first cases such as 
				// stackaddr = ebp+12 or ebp-12 or ebp or ebp+eax
				// ie. stackoffset = 12 or -12 or 0 or eax
				// TODO: handle case were stackaddr = esi+4*ebx
				if (stackaddr.contains("+"))
				{
					stackoffset = stackaddr.substring(stackaddr.indexOf('+')+1, stackaddr.length());
				}
				else if (stackaddr.contains("-"))
				{
					stackoffset = stackaddr.substring(stackaddr.indexOf('-'), stackaddr.length());
				}
				else
				{
					stackoffset = "0";
				}
				
				
				// Get the stackreg name, ie the base addr. 
				// eg. if ebp+12, stackreg = "ebp"
				stackreg = stackaddr.substring(0, 3);
			}
			else if (s.startsWith("push"))
			{
				// basically translates to
				// sub realsp, 4H
				// mov esi, realsp
				// ...do the offsetcalc thing
				// mov WORDSIZE ptr [esi], REG
				
				type = "push";
				
				// get rid of the "push"
				// what is left should be the register to push
				reg = s.substring(4);
				
				stackreg = "realsp"; // even though realsp is not a register, it's ok
									 // because we always move realsp into esi
				stackoffset = "0";
				movetype = "mov";
				wordsize = sizeOfReg(reg);
				isReg2stack = true;
	
			}
			else if (s.startsWith("pop"))
			{
				// basically translates to
				// mov esi, realsp
				// ... do the offsetcalc thing
				// mov REG, WORDSIZE ptr [esi]
				// add realsp, 4H
				
				type = "pop";
				
				// get rid of the "pop"
				// what is left should be the register to pop
				reg = s.substring(3);
				
				stackreg = "realsp";
				stackoffset = "0";
				movetype = "mov";
				wordsize = sizeOfReg(reg);
				isReg2stack = false;
			}
			else if (s.startsWith("call"))
			{
				// IDEA:
				// Subtract realsp by 4
				// Save ecx and esi's value
				// Obtain realsp's addr using offsetcalc ==> esi
				// eip ==> ecx (using the geteip trick)
				// add ecx, SOMEVALUE (to skip over the next instructions)
				// mov dword ptr [esi], ecx
				// Restore ecx and esi to their original value
				// jmp CALL_LABEL
				// A bunch of NOPs
				
				type = "call";
				stackreg = "realsp";
				stackoffset = "0";
				movetype = "mov";
				wordsize = "dword";
				isReg2stack = true;
				reg = "ecx";
			}
			else if (s.equals("ret"))
			{		
				// IDEA:
				// Save ecx and esi's value
				// Obtain the return address from stack and put into ecx
				// push ecx (this moves esp!!)
				// Restore ecx and esi's value
				// ret (this moves esp back to place!!)
				
				type = "ret";
				stackreg = "realsp";
				stackoffset = "0";
				movetype = "mov";
				wordsize = "dword";
				isReg2stack = false;
				reg = "ecx";
			}
			else
			{
				System.err.println("Unrecognisable instruction somehow got here?");
				return;
			}
			
			
			// Let's print the variables out here
			System.out.println("type = " + type);
			System.out.println("isReg2stack = " + isReg2stack);
			System.out.println("movetype = " + movetype);
			System.out.println("reg = " + reg);
			System.out.println("wordsize = " + wordsize);
			System.out.println("stackoffset = " + stackoffset);
			System.out.println("stackreg = " + stackreg);
			System.out.println("");
			
			// Now we have the necessary info
			// For what to replace in the different cases
			// Please refer to Le Manuel for additional comments
			outputfile.println("; " + lines.get(i));
			
			if (type.equals("push") || type.equals("call"))
			{
				outputfile.println("sub realsp, 4H");
			}
		
			if (type.equals("call") || type.equals("ret"))
			{
				outputfile.println("mov tomove, ecx");
			}
			
			outputfile.println("mov temp1si, esi");
			outputfile.println("mov esi, " + stackreg);
			outputfile.println("mov addroffset, " + stackoffset);
			outputfile.println("call get_eip_" + geteipnum);
			outputfile.println("get_eip_" + geteipnum + ":");
				// increment geteipnum for the trick to get content of EIP
				geteipnum++;
				System.out.println("geteipnum = " + geteipnum);
			outputfile.println("pop retaddress");
			outputfile.println("add retaddress, 15h");
			outputfile.println("jmp offsetcalc"); 
			outputfile.print(" nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop\n nop \n nop \n nop \n");
			outputfile.println("mov eax, tempax");
			
			if (type.equals("call"))
			{
				
				outputfile.println("call get_eip_" + geteipnum);
				outputfile.println("get_eip_" + geteipnum + ":");
					// increment geteipnum for the trick to get content of EIP
					geteipnum++;
					System.out.println("geteipnum = " + geteipnum);
				outputfile.println("pop ecx");
				outputfile.println("add ecx, 35H"); // Not sure if 30H is too much/not enough??
													// To skip over the next instructions into the bunch of NOPs below
			}
			
			
			if (isReg2stack)
			{
				outputfile.println(movetype + " " + wordsize + " ptr [esi], " + reg);
			}
			else
			{
				outputfile.println(movetype + " " + reg + ", " +  wordsize + " ptr [esi]");
			}
			outputfile.println("mov esi, temp1si"); // return esi to its orig value
			
			if (type.equals("pop"))
			{
				outputfile.println("add realsp, 4H");
			}
			
			if (type.equals("call"))
			{
				outputfile.println("mov ecx, tomove"); // return ecx to its orig value
				outputfile.println("jmp " + s.substring(4, s.indexOf(':'))); // s.substring(4) == the label to call
				// a bunch of NOPs... not sure how many is sufficient
				outputfile.print(" nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop\n nop \n nop \n nop \n");
				outputfile.print(" nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop\n nop \n nop \n nop \n");
				outputfile.print(" nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop\n nop \n nop \n nop \n");
			}
			
			if (type.equals("ret"))
			{
				outputfile.println("add realsp, 4H"); 
				outputfile.println("push ecx"); // this will be moving the esp!!
				outputfile.println("mov ecx, tomove"); //give ecx back its original value
				outputfile.println("ret"); //this returns using the ecx value we just pushed (at esp)
			}
			
			outputfile.println("");
		}
		
		outputfile.close();
	}
	
	
	
	
	// Removes spaces and comments and makes everything lower case
	static String removeSpaces(String s)
	{
		String line = "";
		for(int i=0;i<s.length();i++)
		{
			if(s.charAt(i) == ' ' || s.charAt(i)=='\t' || s.charAt(i) == '\n' || s.charAt(i) == '\r')
			{
				
			}
			else
			{
				line = line+(s.charAt(i)+"").toLowerCase();
			}
		}
		if (line.indexOf(';') == -1)
			return line;
		else
			return line.substring(0,line.indexOf(';'));
	} 
	
	
	// Outputs wordsize = byte, word, dword 
	// based on input register. eg. ebx -> dword
	// Assume reg is all lower, 2~3 letter String
	
	static String sizeOfReg(String reg)
	{
		if (reg.startsWith("e"))
		{
			return "dword";
		}
		if (reg.endsWith("x") || reg.endsWith("p") || reg.endsWith("i"))
		{
			return "word";
		}
		if (reg.endsWith("l") || reg.endsWith("h"))
		{
			return "byte";
		}
		
		// if not in list above...
		return "N/A";
	}
	

	
}
