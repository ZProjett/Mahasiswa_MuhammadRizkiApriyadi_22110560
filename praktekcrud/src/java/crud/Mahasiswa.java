/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package crud;

import java.sql.*;

public class Mahasiswa {
    public String nim;
    public String nama;
    public int nilai;

    private final String DBDRIVER = "com.mysql.cj.jdbc.Driver";
    private final String DBCONNECTION = "jdbc:mysql://localhost:3306/crud";
    private final String DBUSER = "root";
    private final String DBPASS = "";

    public boolean tambah() {
        try {
            Class.forName(DBDRIVER);
            Connection conn = DriverManager.getConnection(DBCONNECTION, DBUSER, DBPASS);
            String sql = "INSERT INTO mahasiswa (nim,nama,nilai) VALUES (?,?,?)";
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, nim);
            st.setString(2, nama);
            st.setInt(3, nilai);
            st.executeUpdate();
            conn.close();
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    // Tambahkan method lain nanti: edit(), hapus(), getAll(), getById() sesuai kebutuhan.
}

