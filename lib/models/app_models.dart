part of '../main.dart';

class InspectionTicket {
  const InspectionTicket({
    required this.id,
    required this.customer,
    required this.vehicle,
    required this.registration,
    required this.package,
    required this.status,
    required this.priority,
    required this.customerType,
    required this.progress,
    required this.sections,
  });

  final String id;
  final String customer;
  final String vehicle;
  final String registration;
  final String package;
  final String status;
  final String priority;
  final CustomerType customerType;
  final double progress;
  final List<InspectionSection> sections;
}

class CreatedJob {
  const CreatedJob({
    required this.id,
    required this.customerName,
    required this.mobileNumber,
    required this.email,
    required this.address,
    required this.vehicleNumber,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.vehicleType,
    required this.motorNumber,
    required this.batteryNumber,
    required this.odometerReading,
    required this.registrationDate,
    required this.status,
    required this.scheduleTime,
    required this.location,
    this.othersNotes = '',
    this.isDraft = false,
  });

  final String id;
  final String customerName;
  final String mobileNumber;
  final String email;
  final String address;
  final String vehicleNumber;
  final String vehicleBrand;
  final String vehicleModel;
  final String vehicleType;
  final String motorNumber;
  final String batteryNumber;
  final String odometerReading;
  final String registrationDate;
  final String status;
  final String scheduleTime;
  final String location;
  final String othersNotes;
  final bool isDraft;

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'mobileNumber': mobileNumber,
        'email': email,
        'address': address,
        'vehicleNumber': vehicleNumber,
        'vehicleBrand': vehicleBrand,
        'vehicleModel': vehicleModel,
        'vehicleType': vehicleType,
        'motorNumber': motorNumber,
        'batteryNumber': batteryNumber,
        'odometerReading': odometerReading,
        'registrationDate': registrationDate,
        'status': status,
        'scheduleTime': scheduleTime,
        'location': location,
        'othersNotes': othersNotes,
        'isDraft': isDraft,
      };

  factory CreatedJob.fromJson(Map<String, dynamic> json) => CreatedJob(
        id: json['id'] as String? ?? '',
        customerName: json['customerName'] as String? ?? '',
        mobileNumber: json['mobileNumber'] as String? ?? '',
        email: json['email'] as String? ?? '',
        address: json['address'] as String? ?? '',
        vehicleNumber: json['vehicleNumber'] as String? ?? '',
        vehicleBrand: json['vehicleBrand'] as String? ?? '',
        vehicleModel: json['vehicleModel'] as String? ?? '',
        vehicleType: json['vehicleType'] as String? ?? '',
        motorNumber: json['motorNumber'] as String? ?? '',
        batteryNumber: json['batteryNumber'] as String? ?? '',
        odometerReading: json['odometerReading'] as String? ?? '',
        registrationDate: json['registrationDate'] as String? ?? '',
        status: json['status'] as String? ?? 'Draft',
        scheduleTime: json['scheduleTime'] as String? ?? 'Today, 11:30 AM',
        location: json['location'] as String? ?? 'EV Care Service Centre',
        othersNotes: json['othersNotes'] as String? ?? '',
        isDraft: json['isDraft'] as bool? ?? true,
      );
}

class InspectionResult {
  const InspectionResult({
    required this.passed,
    required this.action,
    required this.cost,
    required this.remarks,
  });

  final bool passed;
  final String action;
  final int cost;
  final String remarks;
}

class ServiceInspectionRecord {
  ServiceInspectionRecord({
    required this.id,
    required this.job,
    required this.results,
    Map<String, bool>? serviceProgress,
    this.status = 'Estimate Ready',
  }) : serviceProgress = serviceProgress ??
            {
              for (final item in results.entries)
                if (!item.value.passed) item.key: false,
            };

  final String id;
  final CreatedJob job;
  final Map<String, InspectionResult> results;
  final Map<String, bool> serviceProgress;
  String status;

  int get totalEstimate {
    return results.values.fold<int>(
      0,
      (total, result) => total + (result.passed ? 0 : result.cost),
    );
  }

  int get partsEstimate {
    final order = DemoData.orderByJob(job);
    return order?.totalAmount ?? 0;
  }

  int get grandTotalEstimate => totalEstimate + partsEstimate;

  int get failedCount => results.values.where((result) => !result.passed).length;

  int get completedServiceCount {
    return serviceProgress.values.where((done) => done).length;
  }

  bool get isServiceComplete {
    return serviceProgress.isNotEmpty &&
        completedServiceCount == serviceProgress.length;
  }
}

enum CustomerType { serviceCenter, individualUser }

class InspectionSection {
  const InspectionSection(this.title, this.done, this.icon);

  final String title;
  final bool done;
  final IconData icon;
}

class TimelineItem {
  const TimelineItem(this.title, this.subtitle, this.done);

  final String title;
  final String subtitle;
  final bool done;
}

class InventoryItem {
  const InventoryItem(this.name, this.qty, this.status, this.icon);

  final String name;
  final String qty;
  final String status;
  final IconData icon;
}

class AccessoryPart {
  const AccessoryPart({
    required this.name,
    required this.category,
    required this.price,
    required this.priceAmount,
    required this.stock,
    required this.imageAsset,
    required this.icon,
  });

  final String name;
  final String category;
  final String price;
  final int priceAmount;
  final String stock;
  final String imageAsset;
  final IconData icon;
}

class ServiceOrder {
  const ServiceOrder({
    required this.id,
    required this.job,
    required this.area,
    required this.parts,
    required this.totalAmount,
    required this.status,
    this.deliveryDate = '',
    this.deliveryTime = '',
    this.notes = '',
  });

  final String id;
  final CreatedJob job;
  final String area;
  final List<AccessoryPart> parts;
  final int totalAmount;
  final String status;
  final String deliveryDate;
  final String deliveryTime;
  final String notes;
}

class FormSectionData {
  const FormSectionData(
    this.title,
    this.icon, {
    this.fields = const [],
    this.checks = const [],
    this.passFailChecks = const [],
    this.photos = const [],
  });

  final String title;
  final IconData icon;
  final List<String> fields;
  final List<String> checks;
  final List<String> passFailChecks;
  final List<String> photos;
}

class LegalSection {
  const LegalSection(this.title, this.content);

  final String title;
  final String content;
}

void _showScreenSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.primary,
    ),
  );
}
