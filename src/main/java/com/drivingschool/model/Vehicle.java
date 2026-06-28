package com.drivingschool.model;

import com.drivingschool.model.contract.Identifiable;

import java.time.LocalDateTime;

/** Maps to the `vehicles` table. */
public class Vehicle implements Identifiable {

    /** Identifiable contract: a vehicle is identified by its vehicle_id. */
    @Override
    public int getId() { return vehicleId; }


    private int           vehicleId;
    private String        registrationNo;
    private String        make;
    private String        model;
    private int           year;
    private String        transmissionType;
    private String        fuelType;
    private int           seatingCapacity = 5;   // total seats (incl. instructor)
    private String        status;
    private String        category;
    private String        vehicleType;
    private LocalDateTime createdAt;

    public Vehicle() {}

    /** Seats available for students (1 seat always taken by the instructor). */
    public int getStudentCapacity() {
        return Math.max(1, seatingCapacity - 1);
    }

    // ---- Getters & Setters ----
    public int getVehicleId()                              { return vehicleId; }
    public void setVehicleId(int vehicleId)                { this.vehicleId = vehicleId; }

    public String getRegistrationNo()                      { return registrationNo; }
    public void setRegistrationNo(String registrationNo)   { this.registrationNo = registrationNo; }

    public String getMake()                                { return make; }
    public void setMake(String make)                       { this.make = make; }

    public String getModel()                               { return model; }
    public void setModel(String model)                     { this.model = model; }

    public int getYear()                                   { return year; }
    public void setYear(int year)                          { this.year = year; }

    public String getTransmissionType()                    { return transmissionType; }
    public void setTransmissionType(String transmissionType){ this.transmissionType = transmissionType; }

    public String getFuelType()                            { return fuelType; }
    public void setFuelType(String fuelType)               { this.fuelType = fuelType; }

    public int getSeatingCapacity()                        { return seatingCapacity; }
    public void setSeatingCapacity(int seatingCapacity)    { this.seatingCapacity = seatingCapacity; }

    public String getStatus()                              { return status; }
    public void setStatus(String status)                   { this.status = status; }

    public String getCategory()                            { return category; }
    public void setCategory(String category)               { this.category = category; }

    public String getVehicleType()                          { return vehicleType; }
    public void setVehicleType(String vehicleType)          { this.vehicleType = vehicleType; }

    public LocalDateTime getCreatedAt()                    { return createdAt; }
    public void setCreatedAt(LocalDateTime t)              { this.createdAt = t; }
}