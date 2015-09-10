import java.io.File;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.lang.reflect.Parameter;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.google.gson.Gson;

public class Reflection {
	public static void main(String[] args) throws ClassNotFoundException, MalformedURLException {
		
		Class<?> obj = Class.forName(args[0]);
		Reflection rfl = new Reflection();
//		Class<?> obj = rfl.getClassRef("/Users/faizshukri/Documents/Sheffields/Dissertation/myapp/storage/app/", args[0]);
		// Get all methods
		Method[] methods = obj.getDeclaredMethods();
		
		// Put all methods in this array
		ArrayList<Object> methods_all = new ArrayList<>();
		
		// Process with constructor first
		Constructor<?>[] constructors = obj.getDeclaredConstructors();
		for(Constructor<?> constructor : constructors){
			
			Map<String, Object> method_map = new HashMap<String, Object>();
			
			Parameter[] parameters = constructor.getParameters();
			ArrayList<String> method_parameters = new ArrayList<>();
			for(Parameter parameter : parameters){
				method_parameters.add(parameter.getName());
			}
			// Put names
			method_map.put("name", constructor.getName());
			// Add parameters to this method
			method_map.put("parameters", method_parameters);
			method_map.put("return", true);
			method_map.put("returnType", constructor.getName());
			
			methods_all.add(method_map);
		}
		
		
		// Root map
		Map<String, Object> root = new HashMap<String, Object>();
		root.put("class_name", obj.getName());
		
		for(Method method : methods){
			// Root map
			Map<String, Object> method_map = new HashMap<String, Object>();
			
			// Set method name
			method_map.put("name", method.getName());
			
			// Set method parameters
			Parameter[] parameters = method.getParameters();
			ArrayList<String> method_parameters = new ArrayList<>();
			for(Parameter parameter: parameters){
				method_parameters.add(parameter.getName());
			}

			// Add parameters to this method
			method_map.put("parameters", method_parameters);
			
			// Set method return flag
			if(method.getReturnType().toString().equals("void")){
				method_map.put("return", false);
				method_map.put("returnType", "");
			} else {
				method_map.put("return", true);
				
				// if returnType return string like "class java.lang.String",
				// we only want to get the last one
				String pattern = "\\.?([^\\.]+)$";
				Pattern r = Pattern.compile(pattern);
				Matcher m = r.matcher(method.getReturnType().toString());
				
				if(m.find())
					method_map.put("returnType", m.group(1));
				else
					method_map.put("returnType", "");
			}
			
			methods_all.add(method_map);
		}
		root.put("methods", methods_all);
		
		Gson gson = new Gson();
		System.out.print(gson.toJson(root));
	}
	
	public Class getClassRef(String path, String className) throws ClassNotFoundException, MalformedURLException {
		URL[] dirUrl = new URL[]{ new URL( "file://" + path ) };
		// 1
		URLClassLoader cl = new URLClassLoader(dirUrl);  // 2
		
		Class<?> objClass = cl.loadClass(className);
		
		return objClass;
	}
}
