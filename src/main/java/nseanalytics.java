/**
 * Created by kiranya on 25/4/18.
 */

import java.sql.*;
import java.text.DecimalFormat;
import java.util.*;
import org.apache.commons.math3.stat.regression.SimpleRegression;

public class nseanalytics {

    // Format for decimals.. Needs updating..
    private static final DecimalFormat df = new DecimalFormat("##.##");

    // IP address of the DB host is hardcoded to avoid using Ative DB..
    private static String dbHostIP = "localhost";
    private static String dbName = "eqnse";
    private static String dbUserName = "nseuser";
    private static String dbPwd = "INSERT_PWD";
    private static String startDate = "INSERT_PWD";
    private static String endDate = "INSERT_PWD";

    private static TreeMap<String,Double> priceFit = new TreeMap<>();
    private static TreeMap<String,Double> tradedVolumeFit = new TreeMap<>();
    private static TreeMap<String,Double> deliveredVolumeFit = new TreeMap<>();

    private static Map<String,nseeqobj> scripMap = new HashMap<>();

    // Can be set not to compute intercept
    private static SimpleRegression simpleRegression = new SimpleRegression(true);

    public static void main(String args[]) throws SQLException {

        // Map variables with commandline args
        dbPwd = args[0];
        startDate = args[1];
        endDate = args[2];

        // DB Conn string
        String connectionString = "jdbc:postgresql://" + dbHostIP + ":5432/nsedb";

        // Connection Aquisition
        Connection con = DriverManager
                .getConnection(connectionString, dbUserName , dbPwd);

        // Get unique records
        String getUniqueScrips = "select distinct ISIN, SERIES, SYMBOL, MKTDATE from "+ dbName + " where MKTDATE BETWEEN '" + startDate + "' and '" + endDate +"' order by ISIN, SERIES;";
        Statement stmt_getUniqueScrips = con.createStatement();
        ResultSet rs_stmt_getUniqueScrips;


        // Clear old records
        String deleteFromPriceSlope = "delete from priceslope;";
        String deleteFromVolumeSlope = "delete from volumeslope;";

        int deletedRecords;

        nseeqobj scrip;

        String getRecordsForScrip;
        Statement stmt_getRecordsForScrip;
        ResultSet rs_getRecordsForScrip;

        String isin;
        String series;

        double highPrice;
        double tradedVolume;

        int tmpOuterCounter = 0;
        int tmpCounter = 0;

        PreparedStatement priceSlopeInsertStmt = con.prepareStatement("INSERT INTO priceslope (EQNAME, SLOPE) VALUES (?, ?)");
        PreparedStatement volumeSlopeInsertStmt = con.prepareStatement("INSERT INTO volumeslope (EQNAME, SLOPE) VALUES (?, ?)");

        try {

            // Local PostgreSQL JDBC driver
            Class.forName("org.postgresql.Driver");

            // Clear old records
            deletedRecords = stmt_getUniqueScrips.executeUpdate(deleteFromPriceSlope);

            System.out.println("Deleted " + deletedRecords + " records from priceslope table");

            deletedRecords = stmt_getUniqueScrips.executeUpdate(deleteFromVolumeSlope);

            System.out.println("Deleted " + deletedRecords + " records from volumeslope table");

            rs_stmt_getUniqueScrips = stmt_getUniqueScrips.executeQuery(getUniqueScrips);

            while(rs_stmt_getUniqueScrips.next()) {

                scrip = new nseeqobj();

                scrip.setEqName(rs_stmt_getUniqueScrips.getString("ISIN") + rs_stmt_getUniqueScrips.getString("SERIES") + rs_stmt_getUniqueScrips.getString("SYMBOL"));

                //System.out.println("Begin processing for -->"+ scrip.getEqName());

                isin = rs_stmt_getUniqueScrips.getString("ISIN");
                series = rs_stmt_getUniqueScrips.getString("series");

                // Get records for a scrip
                getRecordsForScrip = "select ISIN, SERIES, SYMBOL, HIGH, TOTTRDQTY, TOTALTRADES, MKTDATE from "+ dbName + " where MKTDATE BETWEEN '" + startDate + "' and '" + endDate +"' and ISIN = '" + isin + "' and SERIES = '" + series + "' order by MKTDATE;";

                stmt_getRecordsForScrip = con.createStatement();
                rs_getRecordsForScrip = stmt_getRecordsForScrip.executeQuery(getRecordsForScrip);

                tmpCounter = 0;

                while(rs_getRecordsForScrip.next()) {

                    highPrice = rs_getRecordsForScrip.getDouble("HIGH");
                    tradedVolume = rs_getRecordsForScrip.getDouble("TOTTRDQTY");

                    scrip.getHighPrice().put((double)tmpCounter, highPrice);
                    scrip.getTradedVolume().put((double)tmpCounter, tradedVolume);

                    tmpCounter++;
                }

                scripMap.put(scrip.getEqName(), scrip);

                //System.out.println("Finished processing for -->"+ scrip.getEqName() + "size of map is" + scrip.getHighPrice().size());

                tmpOuterCounter++;
            }

            System.out.println("Size of scrip db is --> " + scripMap.size());

            double[][] eqPriceArray;
            double[][] eqVolumeArray;
            TreeMap<Double, Double> priceMap;
            TreeMap<Double, Double> volumeMap;

            double tmpSlope;

            Set entries;
            Iterator entriesIterator;
            int i;

            for (Map.Entry<String, nseeqobj> entry : scripMap.entrySet()) {

                nseeqobj eqObj = entry.getValue();

                priceMap = eqObj.getHighPrice();
                volumeMap = eqObj.getTradedVolume();

                eqPriceArray = new double[priceMap.size()][2];
                eqVolumeArray = new double[volumeMap.size()][2];

                entries = priceMap.entrySet();
                entriesIterator = entries.iterator();

                i = 0;

                while (entriesIterator.hasNext()) {

                    Map.Entry mapping = (Map.Entry) entriesIterator.next();

                    eqPriceArray[i][0] = (double) mapping.getKey();
                    eqPriceArray[i][1] = (double) mapping.getValue();

                    i++;
                }

                entries = volumeMap.entrySet();
                entriesIterator = entries.iterator();

                i = 0;

                while (entriesIterator.hasNext()) {

                    Map.Entry mapping = (Map.Entry) entriesIterator.next();

                    eqVolumeArray[i][0] = (double) mapping.getKey();
                    eqVolumeArray[i][1] = (double) mapping.getValue();

                    i++;
                }

                //computeSimpleRegression(eqPriceArray, eqObj.getEqName());

                priceSlopeInsertStmt.setString(1, eqObj.getEqName());
                priceSlopeInsertStmt.setDouble(2, computeSimpleRegression(eqPriceArray, eqObj.getEqName() + "_price"));

                volumeSlopeInsertStmt.setString(1, eqObj.getEqName());
                volumeSlopeInsertStmt.setDouble(2, computeSimpleRegression(eqVolumeArray, eqObj.getEqName() + "_volume"));

                priceSlopeInsertStmt.executeUpdate();
                volumeSlopeInsertStmt.executeUpdate();


            }
        }

        catch(Exception e)
        {
            System.out.println(e);
            e.printStackTrace();
        }
        finally {
            // Release connection
            con.close();
        }
    }

    private static double computeSimpleRegression(double[][] data, String eqName) {
        //System.out.println("For " + eqName + " --> " + Arrays.deepToString(data));

        if (data.length >= 2) {
            simpleRegression.clear();

            simpleRegression.addData(data);

            System.out.println("For " + eqName + "--> " + Arrays.deepToString(data) + " -->"
                    + " slope = " + Double.valueOf(df.format(simpleRegression.getSlope()))
                    + ", intercept = " + Double.valueOf(df.format(simpleRegression.getIntercept()))
            );

            return Double.parseDouble(df.format(simpleRegression.getSlope()));
        }
        return 0;

    }

}
