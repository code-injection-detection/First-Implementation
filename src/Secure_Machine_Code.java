import java.util.*;
import java.io.*;
/*
 * This code reads a compiled exe file and then locates the nop instructions
 * and replaces them with the key share values.
 * 
 */

public class Secure_Machine_Code {
	public static void main(String[] args) throws Exception
	{
		String filename = "C:/asm programs/add2_sec.exe";
		String newfilename = filename.substring(0,filename.length()-7)+"ksec.exe";
		//int n = 2;
		
		int num_of_keys = 15;
		// 
		FileInputStream fr = new FileInputStream(new File(filename));
		FileOutputStream fw = new FileOutputStream(new File(newfilename));
		ArrayList<Byte> list = new ArrayList<Byte>();
		ArrayList[] keys = new ArrayList[num_of_keys];
		for(int i=0;i<num_of_keys;i++)
		{
			keys[i] =new  ArrayList<Byte>();
		}
		
		byte[] b =  new byte[1];
		while(fr.available()>0)
		{
			fr.read(b);
			list.add(b[0]);
		}
	    byte[] arr = new byte[list.size()];
	    for(int i=0;i<list.size();i++)
	    {
	    	arr[i] = list.get(i);
	    }
	    int n = arr.length;
	    for(int i=0;i<n-(2+num_of_keys);i++)
	    {
	    	if(arr[i]==-21 && (arr[i+1] == (byte)(num_of_keys+1))) // int -21 = jmp opcode, and the arr[i+1] has to be the offset
	    	{
	    		for(int j=0;j<num_of_keys;j++)
	    		{
	    			byte temp = randomByte();
	    			keys[j].add(temp);
	    			arr[i+2+j] = temp;
	    		}
	    	}
	    }
		
	    for(int i=0;i<num_of_keys;i++)
	    {
	    	try
	    	{
	    		System.out.printf("Keyshare %d : 0x%02X \n",i, xor(keys[i]));
	    	}
	    	catch(IndexOutOfBoundsException e)
	    	{
	    		System.out.println("Index out of bounds in Xor! Perhaps none of the keys were populated with values... And most likey this is because arr[i+1] did not have the value we expected it to have");
	    		System.exit(-1);
	    	}
	    }
	    
	    fw.write(arr);
	    fw.flush();
	    byte t = (byte)0xeb;
		System.out.println(randomByte() + " "+(t == 107 )+" "+t);
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
