class AccountSnapshot {
  int? code;
  String? msg;
  List<SnapshotVos> snapshotVos = <SnapshotVos>[];

  AccountSnapshot({this.code, this.msg});

  AccountSnapshot.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['snapshotVos'] != null) {
      snapshotVos = <SnapshotVos>[];
      json['snapshotVos'].forEach((v) {
        snapshotVos.add(SnapshotVos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.snapshotVos.length > 0) {
      data['snapshotVos'] = this.snapshotVos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SnapshotVos {
  String? type;
  int? updateTime;
  Data? data;

  SnapshotVos({this.type, this.updateTime, this.data});

  SnapshotVos.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    updateTime = json['updateTime'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['updateTime'] = this.updateTime;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  String? totalAssetOfBtc;
  List<Balances>? balances;

  Data({this.totalAssetOfBtc, this.balances});

  Data.fromJson(Map<String, dynamic> json) {
    totalAssetOfBtc = json['totalAssetOfBtc'];
    if (json['balances'] != null) {
      balances = <Balances>[];
      json['balances'].forEach((v) {
        balances?.add(new Balances.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalAssetOfBtc'] = this.totalAssetOfBtc;
    if (this.balances != null) {
      data['balances'] = this.balances?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Balances {
  String? asset;
  String? free;
  String? locked;

  Balances({this.asset, this.free, this.locked});

  Balances.fromJson(Map<String, dynamic> json) {
    asset = json['asset'];
    free = json['free'];
    locked = json['locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['asset'] = this.asset;
    data['free'] = this.free;
    data['locked'] = this.locked;
    return data;
  }
}

class AllCoinInformation {
  String? coin;
  bool? depositAllEnable;
  bool? withdrawAllEnable;
  String? name;
  String? free;
  String? locked;
  String? freeze;
  String? withdrawing;
  String? ipoing;
  String? ipoable;
  String? storage;
  bool? isLegalMoney;
  bool? trading;
  List<NetworkList>? networkList;

  AllCoinInformation(
      {this.coin,
      this.depositAllEnable,
      this.withdrawAllEnable,
      this.name,
      this.free,
      this.locked,
      this.freeze,
      this.withdrawing,
      this.ipoing,
      this.ipoable,
      this.storage,
      this.isLegalMoney,
      this.trading,
      this.networkList});

  AllCoinInformation.fromJson(Map<String, dynamic> json) {
    coin = json['coin'];
    depositAllEnable = json['depositAllEnable'];
    withdrawAllEnable = json['withdrawAllEnable'];
    name = json['name'];
    free = json['free'];
    locked = json['locked'];
    freeze = json['freeze'];
    withdrawing = json['withdrawing'];
    ipoing = json['ipoing'];
    ipoable = json['ipoable'];
    storage = json['storage'];
    isLegalMoney = json['isLegalMoney'];
    trading = json['trading'];
    if (json['networkList'] != null) {
      networkList = <NetworkList>[];
      json['networkList'].forEach((v) {
        networkList?.add(NetworkList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coin'] = this.coin;
    data['depositAllEnable'] = this.depositAllEnable;
    data['withdrawAllEnable'] = this.withdrawAllEnable;
    data['name'] = this.name;
    data['free'] = this.free;
    data['locked'] = this.locked;
    data['freeze'] = this.freeze;
    data['withdrawing'] = this.withdrawing;
    data['ipoing'] = this.ipoing;
    data['ipoable'] = this.ipoable;
    data['storage'] = this.storage;
    data['isLegalMoney'] = this.isLegalMoney;
    data['trading'] = this.trading;
    if (this.networkList != null) {
      data['networkList'] = this.networkList?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NetworkList {
  String? network;
  String? coin;
  String? withdrawIntegerMultiple;
  bool? isDefault;
  bool? depositEnable;
  bool? withdrawEnable;
  String? depositDesc;
  String? withdrawDesc;
  String? specialTips;
  String? name;
  bool? resetAddressStatus;
  String? addressRegex;
  String? memoRegex;
  String? withdrawFee;
  String? withdrawMin;
  String? withdrawMax;
  int? minConfirm;
  int? unLockConfirm;

  NetworkList(
      {this.network,
      this.coin,
      this.withdrawIntegerMultiple,
      this.isDefault,
      this.depositEnable,
      this.withdrawEnable,
      this.depositDesc,
      this.withdrawDesc,
      this.specialTips,
      this.name,
      this.resetAddressStatus,
      this.addressRegex,
      this.memoRegex,
      this.withdrawFee,
      this.withdrawMin,
      this.withdrawMax,
      this.minConfirm,
      this.unLockConfirm});

  NetworkList.fromJson(Map<String, dynamic> json) {
    network = json['network'];
    coin = json['coin'];
    withdrawIntegerMultiple = json['withdrawIntegerMultiple'];
    isDefault = json['isDefault'];
    depositEnable = json['depositEnable'];
    withdrawEnable = json['withdrawEnable'];
    depositDesc = json['depositDesc'];
    withdrawDesc = json['withdrawDesc'];
    specialTips = json['specialTips'];
    name = json['name'];
    resetAddressStatus = json['resetAddressStatus'];
    addressRegex = json['addressRegex'];
    memoRegex = json['memoRegex'];
    withdrawFee = json['withdrawFee'];
    withdrawMin = json['withdrawMin'];
    withdrawMax = json['withdrawMax'];
    minConfirm = json['minConfirm'];
    unLockConfirm = json['unLockConfirm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['network'] = this.network;
    data['coin'] = this.coin;
    data['withdrawIntegerMultiple'] = this.withdrawIntegerMultiple;
    data['isDefault'] = this.isDefault;
    data['depositEnable'] = this.depositEnable;
    data['withdrawEnable'] = this.withdrawEnable;
    data['depositDesc'] = this.depositDesc;
    data['withdrawDesc'] = this.withdrawDesc;
    data['specialTips'] = this.specialTips;
    data['name'] = this.name;
    data['resetAddressStatus'] = this.resetAddressStatus;
    data['addressRegex'] = this.addressRegex;
    data['memoRegex'] = this.memoRegex;
    data['withdrawFee'] = this.withdrawFee;
    data['withdrawMin'] = this.withdrawMin;
    data['withdrawMax'] = this.withdrawMax;
    data['minConfirm'] = this.minConfirm;
    data['unLockConfirm'] = this.unLockConfirm;
    return data;
  }
}
