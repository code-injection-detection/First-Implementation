import java.util.*;
import java.io.*;
/*
 * This code reads a compiled exe file and then locates the nop instructions
 * and replaces them with the key share values.
 * 
 */

public class Secure_Machine_Code_Masm2 {
	public static void main(String[] args) throws Exception
	{
		String filename = "C:/masm32/codesec_sec.exe"; 
		String newfilename = filename.substring(0,filename.length()-4)+"_sec.exe";
		
		// k = size of key share
		int k = 1;

	 
		FileInputStream fr = new FileInputStream(new File(filename));
		FileOutputStream fw = new FileOutputStream(new File(newfilename));
		ArrayList<Byte> list = new ArrayList<Byte>();
		ArrayList[] keys = new ArrayList[k]; // keeps track of the different keys
		
		for(int i=0;i<k;i++)
		{
			keys[i] =new  ArrayList<Byte>(); //initializes the values
		}
		
		byte[] b =  new byte[1];
		while(fr.available()>0) 
		{
			fr.read(b);
			list.add(b[0]);   // add bytes to the list
		}
		System.out.println("List size is : " +list.size());
	    byte[] arr = new byte[list.size()];
	    for(int i=0;i<list.size();i++)
	    {
	    	arr[i] = list.get(i);
	    }
	    int arrlen = arr.length;
	    
	    
	    // This loop goes from the end of the file to the beginning, looking for
	    // the values that signal the end the program
	    // We need a EB 0k followed by k NOPs.
	    // We need to put the ending canary right after the EB 0k
	    boolean end_canary_loop = false;
	    for(int i=arr.length-6;i>=0;i--)
	    {
	    	if(arr[i]== -21)
	    	{
	    		end_canary_loop = true;
	    		// check that there are indeed required (k+1) number of NOPs 
	    		for (int j = i+2; j< i+2+k+1; j++)
	    		{
	    			if (arr[j] != 90)
	    			{
	    				end_canary_loop = false;
	    				break;
	    			}
	    		}
	    		
	    		if (end_canary_loop == false)
	    		{
	    			continue;
	    		}
	    		
	    		// put in value -105 ie 97H into each of the NOPs

	    		for (int j = i+2; j< i+2+k+1; j++)
	    		{
	    			arr[j] = -105;
	    		}
	    	}
	    	
	    	if (end_canary_loop == true)
	    		break;

	    }
	    
	    for(int i=0; i < arrlen; i++)
	    {
	    	
	    	
	    	if(arr[i]==-21 && (arr[i+1] == (byte)(k+1))) // int -21 = byte eb = jmp 
	    	{
	    		
	    		boolean k1nops =  true;   // is true if there are k+1 nops...
	    		for(int x= i+2; x<i+2+k+1 ; x++)
		    	{
		    		if (arr[x] != -112)
		    			k1nops = false;
		    	}
	    		
	    		if (k1nops == false)
	    			continue;
	    		
	    		arr[i+2] = 39; // the layout is eb 0k 27 (<-- canary) keyshare1 keyshare2 ...
	    		for(int j=0;j<k;j++)
	    		{
	    			byte temp = randomByte();
	    			keys[j].add(temp);
	    			arr[i+3+j] = temp;
	    			
	    		}
	    	}
	    	
	    }

	    // Print out all the keyshares 
	    for (int i = 0; i < k; i++)
	    {
	    	for (int j = 0; j < keys[i].size(); j++)
	    	{
	    		System.out.printf("Keyshare %d shares: 0x%02X \n", i, keys[i].get(j));
	    	}
	    	
	    	
	    }
	    for(int i=0;i<k;i++)
	    {
	    	System.out.printf("Keyshare %d : 0x%02X \n",i, xor(keys[i]));
	    }
	    
	    fw.write(arr);
	    fw.flush();
//	    byte t = (byte)0xeb;
//		System.out.println(randomByte() + " "+(t == 107 )+" "+t);
	}
	static byte xor(ArrayList<Byte> list)
	{
		byte b = list.get(0);
		for(int i=1;i<list.size();i++)
		{
			b = (byte)(b^list.get(i));
		}
		return b;
	}
	static byte randomByte()
	{
		return (byte)(Math.random()*128); 
	}

}
