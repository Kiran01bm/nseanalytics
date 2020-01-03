package com.kiran.nse;

/**
 * Created by kiranya on 25/4/18.
 */

import java.util.TreeMap;

public class nseeqobj {

    private String eqName;

    private double slope;

    private TreeMap<Double,Double> highPrice = new TreeMap<>();

    private TreeMap<Double,Double> tradedVolume = new TreeMap<>();

    private TreeMap<Double,Double> deliveredVolume = new TreeMap<>();

    public String getEqName() {
        return eqName;
    }

    public void setEqName(String eqName) {
        this.eqName = eqName;
    }

    public double getSlope() {
        return slope;
    }

    public void setSlope(double slope) {
        this.slope = slope;
    }

    public TreeMap<Double,Double> getHighPrice() {
        return highPrice;
    }

    public void setHighPrice(TreeMap<Double,Double> highPrice) {
        this.highPrice = highPrice;
    }

    public TreeMap<Double,Double> getTradedVolume() {
        return tradedVolume;
    }

    public void setTradedVolume(TreeMap<Double,Double> tradedVolume) {
        this.tradedVolume = tradedVolume;
    }

    public TreeMap<Double,Double> getDeliveredVolume() {
        return deliveredVolume;
    }

    public void setDeliveredVolume(TreeMap<Double,Double> deliveredVolume) {
        this.deliveredVolume = deliveredVolume;
    }



}
