/* Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package recursivesql;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Random;

/**
* @author Bruno Reinicke
 */
public class Crypter {

    public void SaveToFile(String line) {
        FileWriter fw;
        BufferedWriter writer;
        try {
            fw = new FileWriter("C:/Users/Bruno Reinicke/Documents/Hacking/Estudo recursividade SQL/popular_tabela_usuario_a.sql", true);
            writer = new BufferedWriter(fw);
            writer.write(line);
            writer.newLine();
            writer.close();
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
    
    public void randomPassPopTab() {
        String caract = "!#$%&'()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz[]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ\\";
        String senha = "";
        
        for (int i = 0; i < 150; i++) {
            int qtdCharPwd = new Random().nextInt(30);
            int index;
            for (int y = 0; y < qtdCharPwd; y++) {
                index = new Random().nextInt(89);
                senha += caract.charAt(index);
            }
            senha = senha.replace("'", "''");
            if (senha.isEmpty()) 
                i--;
            else
                new Crypter().SaveToFile("INSERT INTO USUARIO_A(ID, SENHA) "+
                                         "VALUES(" + (i + 1) + ", '" + senha + "');");
            senha = "";
        }
    }
    
    public void populaTabela() {
        FileReader fr;
        BufferedReader reader;
        try {
            fr = new FileReader("C:/Users/Bruno Reinicke/Documents/Hacking/Estudo recursividade SQL/lstSenhas_A.txt");
            reader = new BufferedReader(fr);        
            String line = "";         
            int id = 1;
            while (line != null) {
                line = reader.readLine();
                if (line != null) {
                    line = line.replace("'", "''");
                    new Crypter().SaveToFile("INSERT INTO USUARIO_A(ID, SENHA) "+
                                             "VALUES(" + id + ", '" + line + "');");
                }
                id++;
            }
            System.out.println("Pass");
        } catch (IOException ex) {
            //
        }
    }
}