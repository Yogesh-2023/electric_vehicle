part of '../main.dart';

class DemoData {
  static final createdJobs = <CreatedJob>[];
  static final serviceOrders = <ServiceOrder>[];
  static final serviceInspectionRecords = <ServiceInspectionRecord>[];

  static final defaultOpenJobs = <CreatedJob>[
    const CreatedJob(
      id: 'EV-INSP-2045',
      customerName: 'Rahul Sharma',
      mobileNumber: '98765 43210',
      email: 'rahul@example.com',
      address: 'EV Care Service Centre',
      vehicleNumber: 'DL 05 EV 4421',
      vehicleBrand: 'Ola Electric',
      vehicleModel: 'Ola S1 Pro',
      vehicleType: 'Electric Scooter',
      motorNumber: 'MTR2045',
      batteryNumber: 'BAT2045',
      odometerReading: '12480',
      registrationDate: '12/04/2024',
      status: 'Pre-Service',
      scheduleTime: 'Today, 11:30 AM',
      location: 'EV Care Service Centre',
    ),
    const CreatedJob(
      id: 'EV-INSP-2046',
      customerName: 'Neha Deshmukh',
      mobileNumber: '98765 43210',
      email: 'neha@example.com',
      address: 'EV Care Service Centre',
      vehicleNumber: 'KA 03 EX 7788',
      vehicleBrand: 'Ather',
      vehicleModel: 'Ather 450X',
      vehicleType: 'Electric Scooter',
      motorNumber: 'MTR2046',
      batteryNumber: 'BAT2046',
      odometerReading: '8420',
      registrationDate: '08/03/2024',
      status: 'Job Sheet',
      scheduleTime: 'Today, 11:30 AM',
      location: 'EV Care Service Centre',
    ),
  ];

  static List<CreatedJob> get openJobs => [
        ...DraftService.drafts,
        ...createdJobs,
        ...defaultOpenJobs,
      ];

  static ServiceInspectionRecord? inspectionForJob(CreatedJob job) {
    for (final record in serviceInspectionRecords) {
      if (record.job.id == job.id) return record;
    }
    return null;
  }

  static ServiceOrder? orderByJob(CreatedJob job) {
    for (final order in serviceOrders) {
      if (order.job.id == job.id) return order;
    }
    return null;
  }

  static ServiceInspectionRecord saveInspection({
    required CreatedJob job,
    required Map<String, InspectionResult> results,
  }) {
    final existing = inspectionForJob(job);
    if (existing != null) {
      existing.results
        ..clear()
        ..addAll(results);
      existing.serviceProgress
        ..clear()
        ..addEntries(
          results.entries
              .where((entry) => !entry.value.passed)
              .map((entry) => MapEntry(entry.key, false)),
        );
      existing.status = 'Estimate Ready';
      return existing;
    }

    final record = ServiceInspectionRecord(
      id: 'EST-${serviceInspectionRecords.length + 3001}',
      job: job,
      results: Map<String, InspectionResult>.from(results),
    );
    serviceInspectionRecords.insert(0, record);
    return record;
  }

  static final inspections = <InspectionTicket>[
    InspectionTicket(
      id: 'EV-INSP-2045',
      customer: 'Rahul Sharma',
      vehicle: 'Ola S1 Pro',
      registration: 'DL 05 EV 4421',
      package: 'Battery Diagnostic + General Service',
      status: 'Pre-Service',
      priority: 'Today',
      customerType: CustomerType.serviceCenter,
      progress: 0.36,
      sections: [
        InspectionSection('Vehicle Details', true, Icons.badge_outlined),
        InspectionSection(
          'Battery & BMS Health',
          false,
          Icons.battery_charging_full,
        ),
        InspectionSection('Motor Diagnostics', false, Icons.electric_bolt),
        InspectionSection(
          'Brakes, Tyres & Suspension',
          false,
          Icons.two_wheeler,
        ),
        InspectionSection(
          'Electrical & Lights',
          false,
          Icons.light_mode_outlined,
        ),
        InspectionSection('Pre-Delivery Check', false, Icons.verified_outlined),
      ],
    ),
    InspectionTicket(
      id: 'EV-INSP-2046',
      customer: 'Neha Deshmukh',
      vehicle: 'Ather 450X',
      registration: 'KA 03 EX 7788',
      package: 'Periodic Maintenance Scan',
      status: 'Job Sheet',
      priority: 'High',
      customerType: CustomerType.individualUser,
      progress: 0.58,
      sections: [
        InspectionSection('Vehicle Details', true, Icons.badge_outlined),
        InspectionSection(
          'Battery & BMS Health',
          true,
          Icons.battery_charging_full,
        ),
        InspectionSection('Motor Diagnostics', true, Icons.electric_bolt),
        InspectionSection(
          'Brakes, Tyres & Suspension',
          false,
          Icons.two_wheeler,
        ),
        InspectionSection(
          'Electrical & Lights',
          false,
          Icons.light_mode_outlined,
        ),
        InspectionSection('Pre-Delivery Check', false, Icons.verified_outlined),
      ],
    ),
  ];

  static const timeline = [
    TimelineItem('Booking Assigned', 'Customer service request received', true),
    TimelineItem(
      'Pre-Service Inspection',
      'Initial condition images pending',
      true,
    ),
    TimelineItem(
      'Job Sheet Created',
      'Complaint and service tasks added',
      true,
    ),
    TimelineItem(
      'Inventory Check',
      'Brake pads and connector stock review',
      false,
    ),
    TimelineItem(
      'Pre-Delivery Inspection',
      'Final quality verification',
      false,
    ),
  ];

  static const inventory = [
    InventoryItem('Brake Pads', '12 units', 'Healthy', Icons.speed),
    InventoryItem(
      'Charging Port Connector',
      '3 units',
      'Low Stock',
      Icons.power,
    ),
    InventoryItem(
      'Tyre Valve Kit',
      '24 units',
      'Healthy',
      Icons.radio_button_checked,
    ),
    InventoryItem('BMS Sensor Harness', '6 units', 'Watch', Icons.memory),
  ];

  static const accessoryParts = [
    AccessoryPart(
      name: 'Portable Charger 6A',
      category: 'Charging',
      price: 'Rs. 2,499',
      priceAmount: 2499,
      stock: '18 in stock',
      imageAsset: 'assets/images/electric_parts.png',
      icon: Icons.electrical_services_rounded,
    ),
    AccessoryPart(
      name: 'Charging Port Connector',
      category: 'Connector',
      price: 'Rs. 899',
      priceAmount: 899,
      stock: '7 in stock',
      imageAsset: 'assets/images/electirc_part2.png',
      icon: Icons.power_rounded,
    ),
    AccessoryPart(
      name: 'BMS Sensor Harness',
      category: 'Electronics',
      price: 'Rs. 1,299',
      priceAmount: 1299,
      stock: '6 in stock',
      imageAsset: 'assets/images/electric_parts.png',
      icon: Icons.memory_rounded,
    ),
    AccessoryPart(
      name: 'Throttle Grip Set',
      category: 'Controls',
      price: 'Rs. 749',
      priceAmount: 749,
      stock: '14 in stock',
      imageAsset: 'assets/images/electirc_part2.png',
      icon: Icons.tune_rounded,
    ),
    AccessoryPart(
      name: 'Brake Lever Kit',
      category: 'Safety',
      price: 'Rs. 649',
      priceAmount: 649,
      stock: '22 in stock',
      imageAsset: 'assets/images/electric_parts.png',
      icon: Icons.pan_tool_alt_rounded,
    ),
    AccessoryPart(
      name: 'LED Headlamp Unit',
      category: 'Lighting',
      price: 'Rs. 1,799',
      priceAmount: 1799,
      stock: '9 in stock',
      imageAsset: 'assets/images/electirc_part2.png',
      icon: Icons.light_mode_rounded,
    ),
    AccessoryPart(
      name: 'Tyre Valve Kit',
      category: 'Wheel Care',
      price: 'Rs. 299',
      priceAmount: 299,
      stock: '30 in stock',
      imageAsset: 'assets/images/electric_parts.png',
      icon: Icons.radio_button_checked_rounded,
    ),
    AccessoryPart(
      name: 'Controller Cooling Fan',
      category: 'Electronics',
      price: 'Rs. 1,149',
      priceAmount: 1149,
      stock: '11 in stock',
      imageAsset: 'assets/images/electirc_part2.png',
      icon: Icons.ac_unit_rounded,
    ),
  ];
}
