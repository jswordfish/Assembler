package com.v2.airtel;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FileUtils;

public class RunProgram {
	static File currentDirectory = new File(new File(".").getAbsolutePath());
	
	static{
		try {
			boolean notExists = FileUtils.directoryContains(currentDirectory, new File("temp"));
			if(!notExists){
				FileUtils.forceMkdir(new File("temp"));
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.exit(1);
		}
	}
	
	public static String[] runFile(String fileName){
		String compile = "compile.bat ";
		
		try {
			String loc = currentDirectory.getCanonicalPath();
			compile = compile + loc +" "+fileName;
			System.out.println(compile);
			Process process = Runtime.getRuntime().exec(compile,null);
			InputStream is = process.getInputStream();
		    InputStreamReader isr = new InputStreamReader(is);
		    BufferedReader br = new BufferedReader(isr);
		    List<String> lines = new ArrayList<>();
		    String line = "";
		    while (( line = br.readLine()) != null) {
		    	lines.add(line);
		       }
		    String[] strLines = new String[lines.size()];
		    return lines.toArray(strLines);
			//process.
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			String error[] = new String[1];
			error[0] = "Error "+e.getMessage();
			return error;
		}
	}

}
