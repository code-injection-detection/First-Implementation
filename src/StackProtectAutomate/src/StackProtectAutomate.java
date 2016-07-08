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

		String movetype = "N/A";
		String reg = "N/A";
		String stackreg = "N/A";
		String stackaddr = "N/A";
		String stackoffset = "N/A";
		boolean isReg2stack = false;
		String wordsize = "N/A";
		int geteipnum = 0;
		
		for (int i = 0; i < lines.size(); i++)
		{
			System.out.println(lines.get(i));
			// Get the line& remove spaces&comments for easy handling
			String s = removeSpaces(lines.get(i));
			
			// First handle lines like "mov ecx, dword ptr [ebp+12]" 
			// In this case: 
			// reg == "ecx"
			// stackreg == "ebp"
			// stackaddr == "dwordptr[ebp+12]"
			// stackoffset == 12 (positive 12)
			// isReg2stack == false
			// wordsize == dword
			
			if ( s.isEmpty()
			 || !s.substring(0,3).equals("mov")
			 || !s.contains("ptr")
			 || !s.contains("[")
			 || !s.contains("]"))
			{
				//  TODO: should also handle push/pop/call/ret

				outputfile.println(lines.get(i));
				continue;
			}
			
			System.out.println("Line sans comments/spaces: " + s);
			
			// increment geteipnum for the trick to get content of EIP
			geteipnum++;
			
			// remove the mov
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
			System.out.println("movetype = " + movetype);
			
			
			// Check the wordsize (can only handle dword = 4 and byte = 1
			if (s.contains("dwordptr"))
			{
				wordsize = "dword";
			}
			else if (s.contains("byteptr"))
			{
				wordsize = "byte";
			}
			else if (s.contains("wordptr"))
			{
				wordsize = "word";
			}
			else 
			{
				wordsize = "N/A"; // ehhhhhhh can't handle any other size yet
			}
			
			System.out.println("Wordsize = " + wordsize);
			
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
			System.out.println("reg = " + reg);
			
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
			
			System.out.println("stackoffset = " + stackoffset);
			
			// Get the stackreg name, ie the base addr. 
			// eg. if ebp+12, stackreg = "ebp"
			stackreg = stackaddr.substring(0, 3);
			System.out.println("stackreg = " + stackreg);
			System.out.println("");
			
			// Now we have the necessary info
			// For what to replace in the different cases
			// Please refer to Le Manuel
			
			// TODO: actually write those lines in here?
			outputfile.println("mov temp1si, esi");
			outputfile.println("mov esi, " + stackreg);
			outputfile.println("mov addroffset, " + stackoffset);
			outputfile.println("call get_eip_" + geteipnum);
			outputfile.println("get_eip_" + geteipnum + ":");
			outputfile.println("pop retaddress");
			outputfile.println("add retaddress, 15h");
			outputfile.println("jmp offsetcalc"); 
			outputfile.print(" nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop \n nop\n nop \n nop \n nop \n");
			outputfile.println("mov eax, tempax");
			if (isReg2stack)
			{
				outputfile.println(movetype + " " + wordsize + " ptr [esi], " + reg);
			}
			else
			{
				outputfile.println(movetype + " " + reg + ", " +  wordsize + " ptr [esi]");
			}
			outputfile.println("mov esi, temp1si\n");
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
	
}
