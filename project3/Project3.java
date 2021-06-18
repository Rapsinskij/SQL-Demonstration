//import required packages
import java.sql.*;
import java.io.*;
import java.util.StringTokenizer;


public class Project3 {
        //database credentials
        static final String USER = "jrapsins";
        static final String PASS = "sqltime";
        static final String DB_URL = "jdbc:oracle:thin:@claros.cs.purdue.edu:1524:strep";
        static final String JDBC_DRIVER = "oracle.jdbc.OracleDriver";
        public static void main(String[] args){
                String currentUser = "";
                int users = 2;
                int roles = 2;
                int actions = 1;
                FileInputStream in = null;
                FileOutputStream out = null;
                Connection conn = null;
                Statement stmt = null;
                try{
                        //register JDBC driver for oracle
                        Class.forName(JDBC_DRIVER);

                        //open connection
                        System.out.println("Connecting to database...");
                        conn = DriverManager.getConnection(DB_URL, USER, PASS);



                        in = new FileInputStream("sample_io_scripts/" + args[0]);
                        out = new FileOutputStream("sample_io_scripts/" + args[1]);
                        int c;
                        String sql;
                        while((c = in.read()) != -1){
                                String str = "";
                                while(c != '\n'){
                                        str += (char) c;
                                        c = in.read();
                                }
                                System.out.println(actions + ": " + str);
                                actions++;
                                StringTokenizer st = new StringTokenizer(str, " ");
                                String command = st.nextToken();
                                if(command.equals("LOGIN")){                                        String uname = st.nextToken();
                                        String pword = st.nextToken();
                                        sql = "SELECT COUNT(*) AS rowcount FROM Users WHERE Username LIKE '" + uname + "' AND Password Like '" + pword  + "'";
                                        stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery(sql);
                                        while(rs.next()){
                                                if(rs.getInt("rowcount") > 0){
                                                        currentUser = uname;
                                                        System.out.println("Login Successful");
                                                }
                                                else{
                                                        System.out.println("Login Denied");
                                                }
                                        }
                                        rs.close();
                                }
                                else if(command.equals("CREATE")){
                                        String item = st.nextToken();

                                        if(item.equals("ROLE")){

                                                String name = st.nextToken();
                                                sql = "SELECT COUNT(*) AS rowcount from Roles where RoleName LIKE '" + name + "'";
                                                stmt = conn.createStatement();
                                                ResultSet rs = stmt.executeQuery(sql);
                                                int count = 0;
                                                while(rs.next()){
                                                        count = rs.getInt("rowcount");
                                                }
                                                rs.close();

                                                if(count == 0){
                                                        sql = "INSERT INTO Roles(RoleId, RoleName) Values(" + roles + ", '" + name + "')";
                                                        stmt.executeUpdate(sql);

                                                }
                                                roles++;
                                                System.out.println("Role Created Successfully");                                        }
                                        else if(item.equals("USER")){
                                                String uname = st.nextToken();
                                                String pword = st.nextToken();
                                                sql = "SELECT COUNT(*) AS rowcount from Users  where Username LIKE '" + uname + "'";
                                                stmt = conn.createStatement();
                                                ResultSet rs = stmt.executeQuery(sql);
                                                int count = 0;
                                                while(rs.next()){
                                                        count = rs.getInt("rowcount");
                                                }
                                                rs.close();

                                                if(count == 0){
                                                        sql = "INSERT INTO Users(UserId, Username, Password) Values(" + users + ", '" + uname  + "', '" + pword + "')";
                                                        stmt.executeUpdate(sql);

                                                }
                                                users++;
                                                System.out.println("User Created Successfully");
                                        }

                                }
                                else if(command.equals("ASSIGN")){
                                        st.nextToken();
                                        String user = st.nextToken();
                                        String role = st.nextToken();
                                        sql = "SELECT UserId From Users WHERE Username LIKE '" + user + "'";
                                        stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery(sql);
                                        int userId = 0;
                                        while(rs.next()){
                                                userId = rs.getInt("UserId");
                                        }
                                        rs.close();                                        sql = "SELECT RoleId From Roles WHERE RoleName LIKE '" + role + "'";
                                        stmt = conn.createStatement();
                                        rs = stmt.executeQuery(sql);
                                        int roleId = 0;
                                        while(rs.next()){
                                                roleId = rs.getInt("RoleId");
                                        }
                                        rs.close();

                                        sql = "SELECT COUNT(*) AS rowcount from UserRoles  where UserId = " + userId + " AND RoleId = " + roleId;
                                        stmt = conn.createStatement();
                                        rs = stmt.executeQuery(sql);
                                        int count = 0;
                                        while(rs.next()){
                                                count = rs.getInt("rowcount");
                                        }
                                        rs.close();

                                        if(count == 0){
                                                sql = "INSERT INTO UserRoles(UserId, RoleId) Values(" + userId + ", " + roleId + ")";
                                                stmt.executeUpdate(sql);
                                        }
                                        System.out.println("Role Assigned Successfully");
                                }
                                else if(command.equals("GRANT")){
                                        if(currentUser.equals("admin")){
                                                st.nextToken();
                                                String priv = st.nextToken();
                                                int privId = 0;
                                                if(priv.equals("INSERT")){
                                                        privId = 1;
                                                }
                                                else if(priv.equals("SELECT")){
                                                        privId = 2;
                                                }
                                                st.nextToken();
                                                String roleName = st.nextToken(); sql = "SELECT RoleId From Roles WHERE RoleName LIKE '" + roleName + "'";
                                                stmt = conn.createStatement();
                                                ResultSet rs = stmt.executeQuery(sql);
                                                int roleId = 0;
                                                while(rs.next()){
                                                        roleId = rs.getInt("RoleId");
                                                }
                                                rs.close();

                                                st.nextToken();
                                                String tableName = st.nextToken();
                                                sql = "SELECT COUNT(*) AS rowcount from UserPrivileges  where RoleId = " + roleId + " AND PrivId = " + privId;
                                                stmt = conn.createStatement();
                                                rs = stmt.executeQuery(sql);
                                                int count = 0;
                                                while(rs.next()){
                                                        count = rs.getInt("rowcount");
                                                }
                                                rs.close();

                                                if(count == 0){
                                                        sql = "INSERT INTO UserPrivileges(RoleId, PrivId, TableName) Values(" + roleId + ", " + privId + ", '"  + tableName + "')";
                                                        stmt.executeUpdate(sql);
                                                }
                                                System.out.println("Privilege Granted Successfully");
                                        }
                                        else{
                                                System.out.println("Authorization failure");
                                        }

                                }
                                else if(command.equals("REVOKE")){
                                        if(currentUser.equals("admin")){
                                                st.nextToken();
                                                String priv = st.nextToken();
                                                int privId = 0;
                                                if(priv.equals("INSERT")){
                                                        privId = 1;
                                                }                                               else if(priv.equals("SELECT")){
                                                        privId = 2;
                                                }
                                                st.nextToken();
                                                String roleName = st.nextToken();
                                                st.nextToken();
                                                String tableName = st.nextToken();
                                                sql = "SELECT RoleId From Roles WHERE RoleName LIKE '" + roleName + "'";
                                                stmt = conn.createStatement();
                                                ResultSet rs = stmt.executeQuery(sql);
                                                int roleId = 0;
                                                while(rs.next()){
                                                        roleId = rs.getInt("RoleId");
                                                }
                                                rs.close();
                                                sql = "DELETE FROM UserPrivileges WHERE RoleId = " + roleId + " AND PrivId = " + privId + " AND TableName LIKE '" + tableName + "'";
                                                stmt.executeUpdate(sql);
                                                System.out.println("Privilege Revoked Successfully");

                                        }
                                        else{
                                                System.out.println("Authorization Failure");
                                        }
                                }
                                else{
                                        sql = command;
                                        String priv = command;
                                        int privId = 0;
                                        if(priv.equals("INSERT")){
                                                privId = 1;
                                        }
                                        else if(priv.equals("SELECT")){
                                                privId = 2;
                                        }
                                        if(privId == 1){
                                                String tableName = "";
                                                int i = 0;
                                                while(!(str = st.nextToken()).equals("GET")){
                                                        sql = sql + " " + str;
                                                        i++;
                                                        if(i == 2){
                                                                tableName = str;
                                                        }                                                }
                                                String roleName = st.nextToken();

                                                sql = "SELECT RoleId From Roles WHERE RoleName LIKE '" + roleName + "'";
                                                stmt = conn.createStatement();
                                                ResultSet rs = stmt.executeQuery(sql);
                                                int roleId = 0;
                                                while(rs.next()){
                                                        roleId = rs.getInt("RoleId");
                                                }
                                                rs.close();

                                                String sqlPriv = "SELECT COUNT(*) AS rowcount from UserPrivileges, UserRoles, Users WHERE UserRoles.RoleId = " + roleId + " AND UserRoles.UserId = Users.UserId AND Users.Username LIKE '" + currentUser + "' AND UserPrivileges.PrivId = " + privId + " AND UserPrivileges.TableName LIKE '" + tableName + "'";
                                                stmt = conn.createStatement();
                                                rs = stmt.executeQuery(sqlPriv);
                                                int count = 0;
                                                while(rs.next()){
                                                        count = rs.getInt("rowcount");
                                                }
                                                rs.close();
                                                if(count == 0){
                                                        System.out.println("Authorization Failure");
                                                }
                                                else{
                                                        System.out.println(sql);
                                                        stmt.executeUpdate(sql);
                                                        System.out.println("Row Inserted Successfully");
                                                }
                                        }
                                        else if(privId == 2){
                                                String tableName = "";
                                                while(st.hasMoreTokens()){
                                                        tableName = st.nextToken();
                                                        sql = sql + " " + tableName;
                                                }
                                                String sqlPriv = "SELECT COUNT(*) AS rowcount from UserPrivileges, UserRoles, Users WHERE UserRoles.UserId = Users.UserId AND Users.Username LIKE '" + currentUser + "' AND UserPrivileges.PrivId = " + privId + " AND UserPrivileges.TableName LIKE '" + tableName + "'";
                                                stmt = conn.createStatement();
                                                ResultSet rs = stmt.executeQuery(sqlPriv);
                                                int count = 0;
                                                while(rs.next()){
                                                        count = rs.getInt("rowcount");
                                                }
                                                rs.close();
                                                if(count == 0){
                                                        System.out.println("Authorization Failure");
                                                }
                                                else{
                                                        rs = stmt.executeQuery(sql);
                                                        ResultSetMetaData rsmd = rs.getMetaData();
                                                        System.out.print(rsmd.getColumnName(1) + " ");
                                                        System.out.print(rsmd.getColumnName(2) + " ");
                                                        System.out.print(rsmd.getColumnName(3) + " ");
                                                        System.out.print(rsmd.getColumnName(4) + " ");
                                                        System.out.print(rsmd.getColumnName(5) + " ");
                                                        System.out.print("\n");
                                                }
                                        }
                                }
                        }
                        stmt.close();
                        conn.close();
                        in.close();
                        out.close();

                }catch(Exception e){
                        System.out.println(e);
                }
        }
}






