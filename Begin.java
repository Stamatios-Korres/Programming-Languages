import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Begin {
	static 	int  n,m,k;
	public static void main(String[] args){
		Scanner scanner = null;
		UnionFind x ;
		//Step 1 : Read villages and roads that do exists and form the disjoint sets
		try{
			 scanner = new Scanner(new File(args[0]));
			n = scanner.nextInt(); // Number of villages
			x = new UnionFind(n); 
			m = scanner.nextInt(); // Number of existing roads
			k = scanner.nextInt(); // Number of new roads to be constructed
			int pairs = 0;
			int start,finish;		
			while(pairs<m){
				pairs++;
				start = scanner.nextInt();
				finish = scanner.nextInt();
				x.Union(start-1,finish-1);

			}
			if(x.Result()<k){
				System.out.println(1);
			}
			else{
				System.out.println(x.Result()-k);
			}	
		}
		catch(ArrayIndexOutOfBoundsException e ){
			System.out.println("Give only 1 argument");
		}
		catch(NullPointerException k){
			System.out.println("Oooops");
		}
		catch(FileNotFoundException e){
			System.out.println("No such File");
		}
		finally{
			scanner.close();
			
		}
	}
}
	