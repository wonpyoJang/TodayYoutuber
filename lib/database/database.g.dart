// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String title;
  Category({@required this.id, @required this.title});
  factory Category.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Category(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
    };
  }

  Category copyWith({int id, String title}) => Category(
        id: id ?? this.id,
        title: title ?? this.title,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, title.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Category && other.id == this.id && other.title == this.title);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> title;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    @required String title,
  }) : title = Value(title);
  static Insertable<Category> custom({
    Expression<int> id,
    Expression<String> title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
    });
  }

  CategoriesCompanion copyWith({Value<int> id, Value<String> title}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  final GeneratedDatabase _db;
  final String _alias;
  $CategoriesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn('title', $tableName, false,
        $customConstraints: 'UNIQUE');
  }

  @override
  List<GeneratedColumn> get $columns => [id, title];
  @override
  $CategoriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'categories';
  @override
  final String actualTableName = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Category.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(_db, alias);
  }
}

class Channel extends DataClass implements Insertable<Channel> {
  final int id;
  final String name;
  final String image;
  final String link;
  final String subscribers;
  final int likes;
  final bool isLike;
  final int categoryId;
  Channel(
      {@required this.id,
      @required this.name,
      @required this.image,
      @required this.link,
      @required this.subscribers,
      @required this.likes,
      @required this.isLike,
      @required this.categoryId});
  factory Channel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Channel(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      image:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}image']),
      link: stringType.mapFromDatabaseResponse(data['${effectivePrefix}link']),
      subscribers: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}subscribers']),
      likes: intType.mapFromDatabaseResponse(data['${effectivePrefix}likes']),
      isLike:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_like']),
      categoryId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}category_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || link != null) {
      map['link'] = Variable<String>(link);
    }
    if (!nullToAbsent || subscribers != null) {
      map['subscribers'] = Variable<String>(subscribers);
    }
    if (!nullToAbsent || likes != null) {
      map['likes'] = Variable<int>(likes);
    }
    if (!nullToAbsent || isLike != null) {
      map['is_like'] = Variable<bool>(isLike);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    return map;
  }

  ChannelsCompanion toCompanion(bool nullToAbsent) {
    return ChannelsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      link: link == null && nullToAbsent ? const Value.absent() : Value(link),
      subscribers: subscribers == null && nullToAbsent
          ? const Value.absent()
          : Value(subscribers),
      likes:
          likes == null && nullToAbsent ? const Value.absent() : Value(likes),
      isLike:
          isLike == null && nullToAbsent ? const Value.absent() : Value(isLike),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
    );
  }

  factory Channel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Channel(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      image: serializer.fromJson<String>(json['image']),
      link: serializer.fromJson<String>(json['link']),
      subscribers: serializer.fromJson<String>(json['subscribers']),
      likes: serializer.fromJson<int>(json['likes']),
      isLike: serializer.fromJson<bool>(json['isLike']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'image': serializer.toJson<String>(image),
      'link': serializer.toJson<String>(link),
      'subscribers': serializer.toJson<String>(subscribers),
      'likes': serializer.toJson<int>(likes),
      'isLike': serializer.toJson<bool>(isLike),
      'categoryId': serializer.toJson<int>(categoryId),
    };
  }

  Channel copyWith(
          {int id,
          String name,
          String image,
          String link,
          String subscribers,
          int likes,
          bool isLike,
          int categoryId}) =>
      Channel(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        link: link ?? this.link,
        subscribers: subscribers ?? this.subscribers,
        likes: likes ?? this.likes,
        isLike: isLike ?? this.isLike,
        categoryId: categoryId ?? this.categoryId,
      );
  @override
  String toString() {
    return (StringBuffer('Channel(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('link: $link, ')
          ..write('subscribers: $subscribers, ')
          ..write('likes: $likes, ')
          ..write('isLike: $isLike, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              image.hashCode,
              $mrjc(
                  link.hashCode,
                  $mrjc(
                      subscribers.hashCode,
                      $mrjc(likes.hashCode,
                          $mrjc(isLike.hashCode, categoryId.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Channel &&
          other.id == this.id &&
          other.name == this.name &&
          other.image == this.image &&
          other.link == this.link &&
          other.subscribers == this.subscribers &&
          other.likes == this.likes &&
          other.isLike == this.isLike &&
          other.categoryId == this.categoryId);
}

class ChannelsCompanion extends UpdateCompanion<Channel> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> image;
  final Value<String> link;
  final Value<String> subscribers;
  final Value<int> likes;
  final Value<bool> isLike;
  final Value<int> categoryId;
  const ChannelsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.image = const Value.absent(),
    this.link = const Value.absent(),
    this.subscribers = const Value.absent(),
    this.likes = const Value.absent(),
    this.isLike = const Value.absent(),
    this.categoryId = const Value.absent(),
  });
  ChannelsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required String image,
    @required String link,
    @required String subscribers,
    @required int likes,
    @required bool isLike,
    @required int categoryId,
  })  : name = Value(name),
        image = Value(image),
        link = Value(link),
        subscribers = Value(subscribers),
        likes = Value(likes),
        isLike = Value(isLike),
        categoryId = Value(categoryId);
  static Insertable<Channel> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<String> image,
    Expression<String> link,
    Expression<String> subscribers,
    Expression<int> likes,
    Expression<bool> isLike,
    Expression<int> categoryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (image != null) 'image': image,
      if (link != null) 'link': link,
      if (subscribers != null) 'subscribers': subscribers,
      if (likes != null) 'likes': likes,
      if (isLike != null) 'is_like': isLike,
      if (categoryId != null) 'category_id': categoryId,
    });
  }

  ChannelsCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<String> image,
      Value<String> link,
      Value<String> subscribers,
      Value<int> likes,
      Value<bool> isLike,
      Value<int> categoryId}) {
    return ChannelsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      link: link ?? this.link,
      subscribers: subscribers ?? this.subscribers,
      likes: likes ?? this.likes,
      isLike: isLike ?? this.isLike,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (link.present) {
      map['link'] = Variable<String>(link.value);
    }
    if (subscribers.present) {
      map['subscribers'] = Variable<String>(subscribers.value);
    }
    if (likes.present) {
      map['likes'] = Variable<int>(likes.value);
    }
    if (isLike.present) {
      map['is_like'] = Variable<bool>(isLike.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('link: $link, ')
          ..write('subscribers: $subscribers, ')
          ..write('likes: $likes, ')
          ..write('isLike: $isLike, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }
}

class $ChannelsTable extends Channels with TableInfo<$ChannelsTable, Channel> {
  final GeneratedDatabase _db;
  final String _alias;
  $ChannelsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 60);
  }

  final VerificationMeta _imageMeta = const VerificationMeta('image');
  GeneratedTextColumn _image;
  @override
  GeneratedTextColumn get image => _image ??= _constructImage();
  GeneratedTextColumn _constructImage() {
    return GeneratedTextColumn('image', $tableName, false,
        minTextLength: 0, maxTextLength: 2083);
  }

  final VerificationMeta _linkMeta = const VerificationMeta('link');
  GeneratedTextColumn _link;
  @override
  GeneratedTextColumn get link => _link ??= _constructLink();
  GeneratedTextColumn _constructLink() {
    return GeneratedTextColumn('link', $tableName, false,
        minTextLength: 0, maxTextLength: 2083);
  }

  final VerificationMeta _subscribersMeta =
      const VerificationMeta('subscribers');
  GeneratedTextColumn _subscribers;
  @override
  GeneratedTextColumn get subscribers =>
      _subscribers ??= _constructSubscribers();
  GeneratedTextColumn _constructSubscribers() {
    return GeneratedTextColumn('subscribers', $tableName, false,
        minTextLength: 0, maxTextLength: 255);
  }

  final VerificationMeta _likesMeta = const VerificationMeta('likes');
  GeneratedIntColumn _likes;
  @override
  GeneratedIntColumn get likes => _likes ??= _constructLikes();
  GeneratedIntColumn _constructLikes() {
    return GeneratedIntColumn(
      'likes',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isLikeMeta = const VerificationMeta('isLike');
  GeneratedBoolColumn _isLike;
  @override
  GeneratedBoolColumn get isLike => _isLike ??= _constructIsLike();
  GeneratedBoolColumn _constructIsLike() {
    return GeneratedBoolColumn(
      'is_like',
      $tableName,
      false,
    );
  }

  final VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  GeneratedIntColumn _categoryId;
  @override
  GeneratedIntColumn get categoryId => _categoryId ??= _constructCategoryId();
  GeneratedIntColumn _constructCategoryId() {
    return GeneratedIntColumn('category_id', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES categories (id)');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, image, link, subscribers, likes, isLike, categoryId];
  @override
  $ChannelsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'channels';
  @override
  final String actualTableName = 'channels';
  @override
  VerificationContext validateIntegrity(Insertable<Channel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image'], _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('link')) {
      context.handle(
          _linkMeta, link.isAcceptableOrUnknown(data['link'], _linkMeta));
    } else if (isInserting) {
      context.missing(_linkMeta);
    }
    if (data.containsKey('subscribers')) {
      context.handle(
          _subscribersMeta,
          subscribers.isAcceptableOrUnknown(
              data['subscribers'], _subscribersMeta));
    } else if (isInserting) {
      context.missing(_subscribersMeta);
    }
    if (data.containsKey('likes')) {
      context.handle(
          _likesMeta, likes.isAcceptableOrUnknown(data['likes'], _likesMeta));
    } else if (isInserting) {
      context.missing(_likesMeta);
    }
    if (data.containsKey('is_like')) {
      context.handle(_isLikeMeta,
          isLike.isAcceptableOrUnknown(data['is_like'], _isLikeMeta));
    } else if (isInserting) {
      context.missing(_isLikeMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id'], _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Channel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Channel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ChannelsTable createAlias(String alias) {
    return $ChannelsTable(_db, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $CategoriesTable _categories;
  $CategoriesTable get categories => _categories ??= $CategoriesTable(this);
  $ChannelsTable _channels;
  $ChannelsTable get channels => _channels ??= $ChannelsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [categories, channels];
}
