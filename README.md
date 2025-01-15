# Nimbus Pulse 🌩️
Nimbus Pulse, bulut ve sunucu izleme işlemleri için geliştirilmiş kapsamlı bir uygulamadır. Hedefimiz, kullanıcıların sistemlerini daha verimli bir şekilde yönetmesini, cihazlarının performansını analiz etmesini ve gerçek zamanlı verilerle optimize edilmiş bir deneyim yaşamasını sağlamaktır.

## Mobil Uygulama 🎨
Nimbus Pulse'un mobil uygulaması, Flutter kullanılarak geliştirilmiş ve kullanıcı dostu bir arayüzle tasarlanmıştır. Uygulama, hem bireysel hem de kurumsal kullanıcıların cihaz performansını kolayca izleyebilmesi ve yönetebilmesi için çeşitli özellikler sunar.

### 📊 Performans Analizi
Nimbus Pulse, cihazların performansını detaylı bir şekilde incelemenizi sağlar:

RAM, GPU, Disk Kullanımı: Cihazınızın farklı bileşenlerine ait performans verilerini anlık olarak görüntüleyebilirsiniz.
Grafiklerle Görselleştirme: Performans verileri, anlaşılır ve modern grafiklerle sunulur. Highcharts kütüphanesi kullanılarak şık ve dinamik grafikler oluşturulmuştur.
Geçmiş Veriler: Cihaz performansındaki değişiklikleri geçmişe dönük olarak analiz etme imkanı sunar.
### ⚙️ Özelleştirilebilir Ayarlar
Mobil uygulama, kullanıcı deneyimini kişiselleştirmek için zengin bir ayarlar menüsü sunar:

Profil Yönetimi: Ad, soyad, e-posta gibi kişisel bilgilerinizi düzenleyebilirsiniz.
Tema Değişikliği: Açık ve koyu tema seçenekleriyle uygulamayı kendi tarzınıza uygun hale getirin.
Dil Seçimi: Çoklu dil desteği ile farklı kullanıcı gruplarına hitap eder.
Şifre Değişikliği: Güvenliğiniz için şifrenizi kolayca güncelleyebilirsiniz.
### 📋 Raporlama
Mobil uygulama üzerinden cihaz kullanım bilgilerini detaylı raporlar halinde inceleyebilir ve dışa aktarabilirsiniz:

PDF ve Excel Formatları: Raporlarınızı farklı formatlarda paylaşarak analizlerinizi zenginleştirebilirsiniz.
Gerçek Zamanlı ve Planlanmış Raporlama: İhtiyacınıza göre anlık rapor oluşturabilir veya düzenli raporlamalar planlayabilirsiniz.

## Backend API 🖥️
.NET Core ile geliştirilen güçlü ve ölçeklenebilir bir altyapı. Nimbus Pulse, backend işlemleri için aşağıdaki yaklaşımları ve teknolojileri kullanır:

### 📂 Veritabanı İşlemleri
SQLite Veritabanı: Hafif ve taşınabilir bir veritabanı çözümü.
Entity Framework Core: ORM kullanılarak veritabanı işlemleri kolaylaştırılmıştır. Migration işlemleri desteklenir.
### 🔧 Servis Katmanı
Uygulama iş mantığı, Servis Katmanı aracılığıyla ayrıştırılmış ve modüler bir yapı oluşturulmuştur. Her servis, belirli bir işlevi gerçekleştirmek için tasarlanmıştır:
Cihaz Servisi: Cihaz performans bilgilerini işlemek ve analiz etmek.
Rapor Servisi: Veritabanından alınan verileri analiz edip dışa aktarılabilir raporlar oluşturmak (PDF, Excel).

### 🔄 AutoMapper Kullanımı
Model ve DTO dönüşümleri için AutoMapper kullanılmıştır. Bu sayede veriler API katmanında daha sade ve kullanışlı bir biçimde sunulur.

### 📄 Veri Transfer Nesneleri (DTO)
API'nin veri transfer performansını optimize etmek ve gereksiz bilgileri gizlemek amacıyla DTO'lar oluşturulmuştur.
Örneğin:
DeviceDto: Cihazın temel bilgilerini içeren DTO.
PerformanceDto: Performans metriklerini içeren DTO.
### 🌐 API Özellikleri
RESTful Tasarım: Tüm CRUD işlemleri RESTful standartlara uygun olarak geliştirilmiştir.

## Özellikler ✨
### Nimbus Pulse Mobil Uygulama 📱
#### Performans İzleme
Cihazların RAM, GPU, disk ve diğer bileşenlerine ait performans verilerini grafiklerle görselleştirin.

#### Kullanıcı Dostu Arayüz
Ayarlar, raporlar ve cihaz yönetimi için özelleştirilebilir seçenekler sunar.

#### Ayarlar Sayfası
Profil yönetimi
Tema değişikliği
Dil ve şifre ayarları
Raporlama
Cihaz kullanım bilgilerini analiz edin ve PDF veya Excel formatında dışa aktarın.

## Kullanım Alanları 🌟
Nimbus Pulse, hem bireyler hem de şirketler için geliştirilmiştir.

### 🛠️ Sistem Yöneticileri
Gerçek zamanlı performans verilerini izleme ve analiz etme.

### 👩‍💻 Bireysel Kullanıcılar
Kendi cihazlarının performansını optimize etme ve izleme.

###  🏢 Kurumlar
Birden fazla cihazın kullanım verilerini analiz ederek yönetim süreçlerini kolaylaştırma.
