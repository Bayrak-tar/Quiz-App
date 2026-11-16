# Türkçe Belgelerde İstem Enjeksiyonu Tespiti: Çok Görünümlü Öğrenme ve RAG Güvenlik Değerlendirmesi

**English title:** Prompt Injection Detection in Turkish Documents: Multi-View Learning and RAG Security Diagnostics

**Belge niteliği:** Mevcut proje kodları ve deney kayıtlarına dayanan bilimsel makale taslağı. Yazar, kurum, hedef dergi ve araştırma etiği/veri paylaşım beyanları gönderim öncesinde tamamlanmalıdır. Makale yapısı SCI/SCIE kapsamındaki bir dergiye hazırlanacak çalışma için düzenlenmiştir; yayın kabulü veya deneysel yeterlilik iddiası içermez.



**Revizyon — 14 Kasım 2026:** Ortak protokollü geliştirme koşuları, çoklu tohumlu sınırlı bütçe pilotları, dış dedektör aktarımı, belge/OCR/RAG ve normalizasyon tanıları ile belirsizlik analizi eklenmiştir. Bağımsız insan etiketli yeni dış test tamamlanmamıştır. Yönetim ve kullanıcı arayüzleri kapsam dışındadır.

## Öz

Getirim destekli üretim (RAG) sistemlerinde dış belgelerin güvenilir görev yönergeleriyle birlikte işlenmesi, belge içeriğine gömülü talimatların görev akışını saptırmasına yol açabilir. Bu çalışmada Türkçe istem enjeksiyonu tespiti için yapısal belge analizi, normalizasyon ve belge düzeyinde çoklu örnek öğrenmesini birleştiren bir yaklaşım değerlendirilmiştir. Tarihsel 2.675 metinlik testte son XLM-R modeli 0,9947 F1, %99,59 recall ve %0,55 yanlış pozitif oranı sağlamıştır. Ayrı tutulan 40 komuttan türetilen kontrolde recall %77,92'ye düşmüştür. Revizyonda ortak kalibrasyon hedefli klasik yöntemler, aynı 1.024 kayıt üzerinde çoklu tohumlu Transformer pilotları ve pencereleme kontrolleri eklenmiştir. Skor ve inceleme bantları birlikte ele alındığında son modelin normal otomatik geçememe oranı %3,52'dir. Sekiz belge biçimindeki 46 kontrollü dosyada tam hat 29 saldırılı örneği işaretlemiş; aynı alıntı örüntüsünün sekiz normal biçim türevinde yanlış alarm üretmiştir. Küçük yerel RAG tanısında saldırı hedefi gerçekleşmesi koruma kapalı/açık koşullarında 6/8'den 0/8'e değişmiş, normal görev başarısı iki kontrolden biriyle sınırlı kalmıştır. Bulgular, yüksek metin F1'inin tek başına belge güvenliğini ve kullanım yararını açıklamadığını göstermektedir. Tarihsel testin tasarımı etkilemesi, kaynak soy ağacının eksikliği, sınırlı bütçeli pilotlar ve bağımsız insan etiketli dış test yokluğu genelleme iddialarını sınırlar.

**Anahtar kelimeler:** dolaylı istem enjeksiyonu; Türkçe doğal dil işleme; RAG güvenliği; XLM-R; mBERT; çoklu örnek öğrenmesi; belge analizi.

## Abstract

Untrusted documents can redirect language model applications when their contents are interpreted as task instructions. This study evaluates a Turkish prompt injection screening approach combining structural document analysis, normalization and document-level multiple-instance learning. The final historical XLM-R model achieves F1=0.9947, recall=99.59% and FPR=0.55% on 2,675 historical texts, while recall decreases to 77.92% on variants of 40 reserved commands. The revision adds common-calibration classical baselines, multiple-seed Transformer pilots using the same 1,024 records, and controlled windowing diagnostics. Including the review band, 3.52% of benign historical texts do not pass automatically. Across 46 constructed format fixtures, the full pipeline flags 29 malicious fixtures but also flags eight benign format variants of one quoted-attack pattern. In a small local RAG diagnostic, exact attack-objective fulfillment changes from 6/8 without screening to 0/8 with screening; benign task success remains 1/2. The findings demonstrate the need to evaluate false blocking and task utility alongside text classification. Historical test feedback, incomplete provenance, limited-budget pilots and the absence of independently human-labeled external data constrain generalization claims.

## 1. Giriş

RAG sistemleri, bir sorguyla ilişkili dış kaynakları getirerek dil modelinin yanıt oluşturma bağlamına ekler. Bu süreçte belgeler bilgi kaynağı olarak kullanılmasına rağmen, içerdikleri emir cümleleri model tarafından görev yönergesi gibi yorumlanabilir. Dolaylı istem enjeksiyonu, saldırganın doğrudan sorgu göndermek yerine sonradan getirilecek bir kaynağa talimat yerleştirmesiyle ortaya çıkar. Veri ile yönerge arasındaki güven sınırının bu biçimde aşılması literatürde uygulamalı örneklerle gösterilmiştir [1].

Türkçe belge güvenliğinde sorun, yalnızca belirli saldırı sözcüklerinin aranmasına indirgenemez. Normal metinlerde de emir kipi, parola kavramı, güvenlik tartışmaları veya alıntılanmış saldırı örnekleri bulunabilir. Ayrıca saldırı metni belgenin sonunda, görünmez karakterlerde, üstveride veya birbirinden uzak parçalarda yer alabilir. Bu nedenle tespit sisteminin hem bağlamsal ayrımı hem belge kapsamını koruması gerekir.

Bu çalışma üç araştırma sorusuna odaklanmaktadır: (AS1) Belge düzeyinde MIL yaklaşımı, mBERT taban çizgisine göre metin düzeyindeki tespiti nasıl değiştirmektedir? (AS2) Kısa pencereler ve uzak parçaları birleştiren görünümler, parçalar arası saldırıların tespitine nasıl yansımaktadır? (AS3) Bu kazanımlar yanlış alarmlar ve eğitimde ayrılan saldırı ifadeleri bakımından hangi sınırlara sahiptir?

Çalışmanın katkısı, yeni bir temel dil modeli önermekten çok, Türkçe belge güvenliği için çok katmanlı analiz hattı ile belge düzeyinde öğrenmeyi aynı değerlendirme çerçevesinde incelemektir. İkinci katkı, eğitim verisi miktarını, pencere sayısını ve değerlendirme birimini ayıran izlenebilir deney raporlamasıdır. Üçüncü katkı ise tarihsel saldırı ifadesi örtüşmesinin ve test geri bildirimiyle geliştirilen yöntemin sonuç yorumunu nasıl sınırladığını açıkça ortaya koymaktır. Yönetim paneli, kullanıcı ekranları, hesap işlemleri ve arayüz tasarımı çalışmanın kapsamı dışındadır.

## 2. İlgili çalışmalar ve kavramsal temel

Dolaylı istem enjeksiyonu üzerine Greshake ve arkadaşlarının çalışması, dış kaynakların güvenilir yönerge alanına taşınmasının oluşturduğu saldırı yüzeyini ele almaktadır [1]. Buradaki proje, bu tehdidin Türkçe belge işleme ve RAG bağlamına uygulanmasını incelemektedir; ilgili yayındaki saldırı başarıları projenin deney sonuçları olarak kullanılmamıştır.

BERT, iki yönlü bağlamsal temsillerin görev odaklı ince ayarla kullanılmasına temel sağlamaktadır [2]. Projedeki tarihsel mBERT sürümleri bu yaklaşımın çok dilli bir checkpoint'inden türetilmiştir. XLM-R ise ölçekli çok dilli ön eğitimle geliştirilmiş bir model ailesidir [3]. XLM-R'ın başka görevlerdeki başarısı, bu çalışmanın enjeksiyon görevinde kendiliğinden üstünlük kanıtı sayılmamaktadır.

MIL yaklaşımında bir örnek kümesine tek etiket atanır; her alt örneğin etiketi ayrıca bilinmek zorunda değildir. Ilse ve arkadaşlarının çalışması bu problemi dikkat tabanlı bir toplama işleviyle ele almaktadır [4]. Bu projede ise dikkat tabanlı toplama uygulanmamış, en yüksek pencere skorunu kullanan hard-max yaklaşımı seçilmiştir. Dolayısıyla yöntem, MIL problem tanımından yararlanmakta; ilgili yayının mimarisini birebir tekrarlamamaktadır.


Düşük yanlış alarm bölgesinde dedektör değerlendirmesi PromptShield'de ele alınmıştır [5]. BIPIA [6], InjecAgent [7] ve AgentDojo [8] güvenlik çıktısı ile normal görev yararının birlikte değerlendirilmesi için farklı kapsamlı örnekler sunar. Bu çalışmaların sonuçları Türkçe test skorlarıyla aynı başarı sıralamasına alınmamıştır. [Literatür konum tablosu](research/publication/LITERATUR_KONUMU.md) yöntem/veri/tehdit farklarını açıklar.

## 3. Materyal ve yöntem

### 3.1. Tehdit modeli ve sistem kapsamı

Saldırganın RAG sistemine alınabilecek dış belge içeriğini değiştirebildiği, buna karşılık tespit modelinin ağırlıklarını veya temel görev yönergesini değiştiremediği varsayılmaktadır. Saldırı; özgün görevi bastırma, önceki yönergeleri geçersiz kılma veya yetkisiz bir davranışa yönlendirme amaçlı olabilir. Birincil görev böyle bir talimatın tespitidir. Revizyonda ayrıca tek yerel üretici modelle küçük bir uçtan uca RAG tanısı yapılmıştır (Bölüm 4.8). Tespit oranları ile bu sınırlı LLM saldırı sonuçları ayrı tutulmuş, tespit recall'u genel saldırı engelleme oranı olarak adlandırılmamıştır.

Analiz hattı aşağıdaki sırayı izlemektedir:

```text
Belge
  → biçime özgü metin ve yapısal içerik çıkarımı
  → ham içerikte gizleme/kodlama göstergelerinin incelenmesi
  → model girdisinin normalizasyonu
  → örtüşmeli ve uzak parçaları birleştiren pencere görünümleri
  → Transformer pencere skorları
  → belge düzeyinde maksimum skor
  → eşik ve tarama kapsamına dayalı karar
  → RAG indeksleme/getirim hattında geçiş denetimi
```

PDF, DOCX, HTML ve TXT temel belge türleri arasındadır. Kodda PPTX, XLSX, EML ve RTF için de metin çıkarımı bulunmaktadır; bu biçimlerin desteklenmesi her biçimde aynı doğrulukla deneysel doğrulama yapıldığı anlamına gelmez. Gerekli durumlarda OCR kullanılır. Beyaz metin, sıfır genişlikli karakterler, üstveri ve Base64 kodlu içerik gibi yüzeyler ayrıca incelenir. Bu katmanlar sınıflandırıcıya ek kanıt sağlar; kodlama veya görünmez karakter varlığı tek başına saldırı niyeti kanıtı olarak yorumlanmamalıdır.

### 3.2. Eğitim verileri

Etiketler normal içerik için 0, enjeksiyon için 1 olarak tanımlanmıştır. Kayıt sayısı, benzersiz metin sayısı ve modele sunulan pencere sayısı farklı büyüklüklerdir. Aynı kayıttan birden fazla pencere üretilebildiğinden pencere sayısı veri kümesindeki bağımsız belge sayısı gibi kullanılamaz.

**Tablo 1. Eğitimde kullanılan veri kümeleri ve aşamalar.**

| Veri/deney | Normal | Saldırı | Toplam kayıt | Kullanım ve açıklama |
|---|---:|---:|---:|---|
| Tarihsel mBERT v6c/v6d karışımı | 6.903 | 4.000 | 10.903 | 8.000 dengeli tampon + 1.357 wiki düz metin + 1.546 wiki HTML metni; 10.672 benzersiz metin |
| mBERT v6d-full karışımı | — | — | 26.663 | Tarihsel kayda göre 23.760 ana eğitim kaydı + 2.903 wiki kaydı; sınıf dökümü bu raporda yeniden doğrulanmadı |
| XLM-R birinci aşama, artırma öncesi eğitim bölümü | 10.327 | 9.129 | 19.456 | Kaynak verinin gruplanarak ayrılan eğitim bölümü |
| XLM-R birinci aşama, artırma sonrası | 11.527 | 10.329 | 21.856 | Gerçek eğitim girdisi; 57.134 pencere |
| XLM-R ikinci aşama, kısa pencere düzeltmesi | 1.352 | 1.352 | 2.704 | Dengeli ek eğitim; 13.914 pencere; ilk adaydan devam |
| Hedefli mBERT ve alternatif omurga deneyleri | — | — | 2.996 | Önceki hedefli deney havuzu; BERTurk'ta 2.893 kayıt kullanılmış, 103 uzun kayıt dışarıda kalmış |
| Klasik TF-IDF ana deneyleri | 6.903 | 4.000 | 10.903 | Tarihsel mBERT karışımıyla aynı dosya; payload ayrımlı ayrı deneyde 10.642 kayıt |
| Revizyon: klasik yöntemlerin tam eğitim bölümü | 11.527 | 10.329 | 21.856 | İlk MIL eğitim dosyasının dondurulmuş kopyası; beş yöntem, üç tohum |
| Revizyon: ortak sınırlı bütçeli pilot | 512 | 512 | 1.024 | Aynı tam eğitim bölümünden sabit seçim; klasik modeller ve Transformer/ablasyon koşulları aynı kayıtları kullanır |

**Kaynak:** İlk iki satır için [tez sürüm notları](tez.md); XLM-R sayıları için [ilk aşama veri manifesti](artifacts/robust_mil_20261012/data/manifest.json), [ek eğitim manifesti](artifacts/robust_mil_refined_20261012/data/manifest.json) ve ilgili eğitim reçeteleri. Alternatif deneyler için [model karşılaştırma kaydı](TUM_MODELLER_KARSILASTIRMA.md). “—” işareti ilgili sınıf sayısının bu raporda doğrulanmadığını gösterir.

Revizyon veri sayıları [dondurulmuş ortak protokolden](artifacts/publication_revision_20261107/experiments/protocol.json) alınmıştır. Pilot 1.024 kayıt tam eğitim bölümünün alt kümesidir; tablo satırları bağımsız veri kümeleri olarak toplanamaz.

İki XLM-R eğitim aşamasında toplam 24.560 kayıt kullanımı vardır; bu sayı benzersiz belge toplamı değildir. İkinci aşama ilk modelin ağırlıklarından devam ettiğinden aşamaların ayrı raporlanması gerekir. İlk aşamadaki artırma, normal bağlamlara saldırı komutlarının taşınmasını ve eşleşen normal kontrol birleşimlerini içerir. İkinci aşamada kısa saldırılar, normal parçalar ve farklı konumlara yerleştirilmiş komutlar kullanılmıştır.

### 3.3. Veri ayrımı ve değerlendirme kümeleri

İlk XLM-R hazırlığında Unicode normalizasyonundan sonra birebir tekrar ve MinHash adayları üzerinden sözcüksel yakınlık kontrolleri uygulanmıştır. Eğitim grupları yaklaşık %80 eğitim, %10 doğrulama ve %10 kalibrasyon hedefiyle ayrılmıştır. Manifestte tanımlanan gruplar arasında örtüşme sıfırdır; ancak üretim ailesi ve kaynak kimlikleri eksik olduğundan bu sonuç anlamsal bağımsızlık kanıtı değildir.

**Tablo 2. Doğrulama, kalibrasyon ve değerlendirme verileri.**

| Bölüm/küme | Normal | Saldırı | Toplam | İşlev |
|---|---:|---:|---:|---|
| İlk aşama doğrulama, artırma sonrası | 1.441 | 1.292 | 2.733 | Epoch/model seçimi |
| İlk aşama kalibrasyon, artırma sonrası | 1.441 | 1.292 | 2.733 | Karar eşiği seçimi |
| İkinci aşama doğrulama | 1.489 | 1.340 | 2.829 | Düzeltme aşamasında model seçimi |
| İkinci aşama kalibrasyon | 1.489 | 1.340 | 2.829 | Son karar eşiği seçimi |
| Ortak Türkçe tarihsel sentetik test | 1.447 | 1.228 | 2.675 | Üç ana modelin karşılaştırılması |
| Tarihsel kısa metin kontrolü | 106 | 25 | 131 | Önceki modellerin regresyon kontrolü |
| Normal tam metin kontrolü | 54 | 0 | 54 | Belge uzunluğu ve içerik kaynaklı yanlış alarmlar |
| Standart cross-chunk | 0 | 100 | 100 | Parçalar arası saldırılı belgelerde yakalama |
| Adaptif cross-chunk | 0 | 100 | 100 | Uyarlanmış parçalar arası saldırılarda yakalama |
| Ayrılmış 40 saldırı ifadesi kontrolü | 240 | 240 | 480 | Bilinen kategorilerde ayrılan ifadelere dayanıklılık |
| Dosya işleme hattı kontrolü | 3 | 14 | 17 | Metin çıkarımı ve karar politikasının birlikte değerlendirilmesi |
| Eski `gercek_test.jsonl` | 1.592 | 801 | 2.393 | Tarihsel deney; saldırı ifadesi örtüşmesi bulunduğu için bağımsız genelleme testi değildir |

**Kaynak:** Veri manifestleri, `regression/*/summary.json`, `holdout/summary.json` ve tarihsel tez kayıtları. Satırlar farklı deney amaçlarını gösterir; birbirinden tamamen bağımsız kümelermiş gibi toplanmamalıdır.

İkinci aşamada 84 eğitim, 8 doğrulama, 8 kalibrasyon ve 40 ayrı kontrol komutu tanımlanmış; tarihsel 20 komut ek eğitimden çıkarılmıştır. Bu, 40 komutun her türlü önceki ön eğitimden bağımsız olduğu anlamına gelmez. Kontrolde mevcut taşıyıcılar ve bilinen saldırı kategorileri kullanılmıştır. Tarihsel test, önceki hataların incelenmesi yoluyla yöntem tasarımını etkilediğinden nihai bağımsız kabul kümesi sayılmamaktadır.

### 3.4. Normalizasyon ve pencereleme

Model girdisinde NFKC normalizasyonu, tanımlı homoglif eşlemeleri ve görünmez Unicode biçim karakterlerinin çıkarılması uygulanmaktadır. Ham içerik, gizleme göstergelerini kaybetmemek amacıyla ayrı korunur. Böylece model girdisinin sadeleştirilmesi ile yapısal kanıtın incelenmesi birbirinden ayrılır.

Uzun görünüm toplam 512 token, örtüşme 128 tokendır. Özel tokenlar nedeniyle içerik kapasitesi 510 tokendır. Belgenin sonunu kapsayan pencere ayrıca eklenir. Baş ve son parçaların birleştirilmesi ile sınırlı sayıdaki komşu olmayan blok çifti, uzak talimat ilişkilerini görünür kılmayı amaçlar. Son modelde toplam 128 tokenlık kısa görünümler de kullanılmaktadır; kodda bu görünümlerin içerik kapasitesi 126, örtüşmesi 64 tokendır. Bu yaklaşım bütün uzak parça kombinasyonlarını kapsamaz.

### 3.5. Belge düzeyinde hard-max MIL

Bir belge için pencere kümesi \(W(D)=\{w_1,\ldots,w_m\}\), pencerenin saldırı skoru \(p_i=f_\theta(w_i)\) olsun. Belge skoru:

\[
s(D)=\max_{i=1,\ldots,m}p_i
\]

olarak tanımlanır. Eğitimde mevcut modelle en yüksek skorlu pencere seçilir:

\[
i^*=\arg\max_i f_\theta(w_i).
\]

Ardından seçilen pencerenin iki sınıflı logitleri ve belge etiketi kullanılarak çapraz entropi kaybı üzerinden güncelleme yapılır. Böylece saldırılı belgenin bütün normal pencereleri pozitif etiketle eğitilmez. Normal belgede seçilen pencere, modelin en çok yanıldığı zor negatif örnektir. Bununla birlikte erken eğitimde seçilen pozitif pencerenin gerçek saldırı aralığını kapsaması garanti değildir.

Maksimum toplama işlevi, tek bir güçlü saldırı göstergesine duyarlıdır. Daha fazla pencerenin değerlendirilmesi normal belgelerde de yüksek skor çıkma olasılığını artırabilir. Bu nedenle uzun belge yanlış alarmları, kısa metin sınıflandırmasından ayrı değerlendirilmiştir. Pencere skoru, ayrıca olasılık kalibrasyonu kanıtlanmadan gerçek saldırı riski yüzdesi olarak yorumlanmamalıdır.

### 3.6. Eğitim düzeni ve karar eşikleri

**Tablo 3. Ana eğitim yapılandırmaları.**

| Özellik | mBERT v6d | XLM-R ilk MIL adayı | XLM-R kısa pencere düzeltmesi |
|---|---|---|---|
| Başlangıç ağırlığı | mBERT v5 | `FacebookAI/xlm-roberta-base` | İlk MIL adayı |
| Eğitim turu | 1 | 2 | 2 |
| Öğrenme oranı | 2 × 10⁻⁵ | 1 × 10⁻⁵ | 3 × 10⁻⁶ |
| Batch büyüklüğü | 32 | 16 | 16 |
| Uzun pencere | 512 | 512 | 512 |
| Ek kısa pencere | — | — | 128 |
| Eğitim pencere sayısı | Kayıtta yok | 57.134 | 13.914 |
| Rastgele tohum | Bu tarihsel kayıtta yok | 42 | 42 |
| Hassasiyet | Bu tarihsel kayıtta yok | BF16 hesaplama, FP32 ana ağırlıklar | BF16 hesaplama, FP32 ana ağırlıklar |
| Sabit katman | Bu tarihsel kayıtta yok | Sözcük embedding tablosu | Sözcük embedding tablosu |
| Karar eşiği | 0,95 | 0,0006986757 | 0,9981897473 |

XLM-R deneyleri NVIDIA GeForce RTX 4060 Laptop GPU üzerinde gerçekleştirilmiştir. Eğitim reçetelerinde 278.045.186 toplam, 86.043.650 eğitilebilir parametre kayıtlıdır. Gradient accumulation 1, gradient checkpointing kapalıdır. Kayıtlı yazılım sürümleri PyTorch `2.12.1+cu126` ve Transformers `5.12.1`'dir. Bu bilgiler özgün tam ölçekli deney reçetelerinden aktarılmıştır; özgün koşular aynen yeniden üretilmemiştir. Revizyonda ayrı klasik eğitimler ve çoklu tohumlu sınırlı bütçe Transformer pilotları çalıştırılmıştır.

Model seçimi doğrulama bölümünde, eşik seçimi ayrı kalibrasyon bölümünde yapılmıştır. Eşikler farklı skor dağılımlarına aittir; ilk ve son adayın eşikleri arasındaki büyüklük farkı doğrudan güvenilirlik farkı değildir. Modeller kendi kayıtlı eşikleriyle karşılaştırıldığı için sonuçlar mimari, veri, pencereleme ve eşik seçiminin toplam etkisini yansıtır.

Revizyon koşuları Python 3.11, PyTorch 2.9.1+cu130 ve Transformers 4.57.3 ortamında yürütülmüştür; tarihsel reçetelerdeki sürümlerle aynı ortam oldukları varsayılmamıştır. Belge deneyinde PyMuPDF 2.1 proje içi izole bağımlılık dizinine kurulmuş, gerçek yerel Tesseract kullanılmıştır. Koşu bazındaki tam sürüm ve hash kayıtları araştırma paketinde korunur.

### 3.7. Karar politikası ve RAG entegrasyonu

Sistem saldırı, temiz, inceleme gerekli ve taranamadı durumlarını ayırır. RAG geçiş denetiminde yalnız açık temiz kararı güvenli kabul edilir. Böylece metin çıkarımı veya tarama hatası otomatik temiz sonucuna dönüşmez. Entegrasyon katmanı şüpheli belgeyi düşürme, işlem durdurma veya metaveriyle işaretleme seçenekleri sunar. İşaretleme seçeneği tek başına engelleme sağlamaz; aşağı akış politikasının işareti dikkate alması gerekir.

Bu ayrım deney yorumunda da önemlidir: saldırı olarak etiketlenmeyen ancak incelemeye yönlendirilen belge, doğrudan tespit edilmiş saldırı sayılmaz; buna karşılık temiz geçirilmiş saldırıyla aynı güvenlik sonucu da değildir.

### 3.8. Değerlendirme ölçütleri

Pozitif sınıf enjeksiyondur. TP yakalanan saldırı, FN kaçırılan saldırı, FP yanlış işaretlenen normal içerik ve TN doğru normal kararıdır.

\[
Precision=\frac{TP}{TP+FP},\quad Recall=\frac{TP}{TP+FN}
\]

\[
F1=\frac{2TP}{2TP+FP+FN},\quad FPR=\frac{FP}{FP+TN}.
\]

F1 ve precision 0–1 aralığında, recall ve FPR gerektiğinde yüzde olarak raporlanmıştır. Yalnız saldırı içeren cross-chunk kümelerinde FPR ve sınıflar arası ayırma başarısı hesaplanamaz; bu kümelerde yalnız yakalama oranı yorumlanır. Deney yazılımının bu kümeler için ürettiği FPR=0 değeri güvenlik kanıtı olarak kullanılmamıştır. Kaynak ve saldırı ailesi bağımlılıkları bilinmeyen tarihsel kümelerde, satırların bağımsızlığını varsayan Wilson aralıkları ana çıkarım olarak kullanılmamıştır. Ham kayıtlardaki bu hesaplamalar korunur. Bölüm 4.4'teki bootstrap yalnız gözlenen payload örneklemine koşulludur; tohum standart sapmaları ise ayrı bir eğitim değişkenliği ölçüsüdür.

## 4. Bulgular

### 4.1. Ortak Türkçe testte model karşılaştırması

**Tablo 4. Aynı 2.675 metin üzerinde üç ana modelin sonuçları.**

| Model | TP | FP | FN | TN | Precision | Recall (%) | F1 | FPR (%) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| mBERT v6d | 1.209 | 28 | 19 | 1.419 | 0,9774 | 98,45 | 0,9809 | 1,94 |
| XLM-R ilk MIL | 1.225 | 10 | 3 | 1.437 | 0,9919 | 99,76 | 0,9947 | 0,69 |
| XLM-R düzeltilmiş MIL | 1.223 | 8 | 5 | 1.439 | 0,9935 | 99,59 | 0,9947 | 0,55 |

**Kaynak:** [mBERT ham özeti](artifacts/robust_mil_20261012/regression/baseline_v6d/summary.json), [ilk aday ham özeti](artifacts/robust_mil_20261012/regression/candidate/summary.json) ve [son aday ham özeti](artifacts/robust_mil_refined_20261012/regression/candidate/summary.json).

Son aday, mBERT'e göre 14 ek saldırıyı yakalamış ve yanlış alarmı 28'den 8'e düşürmüştür. F1 artışı yaklaşık 0,0138, yani 1,38 yüzde puandır. Yanlış alarm sayısındaki göreli azalma %71,43'tür. Bununla birlikte ilk XLM-R adayına göre son model iki saldırıyı daha kaçırırken iki normal metindeki yanlış alarmı gidermiştir. Yuvarlanmış F1 değerleri aynı olsa da ham değerler ilk adayda 0,9947219, son adayda 0,9947133'tür; son adayın bu testte F1 üstünlüğü yoktur.

Güvenilir kaynak/aile kümeleri bulunmadığından bu tarihsel oranlar için popülasyon güven aralığı ileri sürülmemiştir. AS1 bakımından sonuç, bu veri ve kayıtlı eşiklerde XLM-R MIL yapılandırmasının daha yüksek F1 ve daha düşük FPR sağlamasıdır; fark tek başına omurga değişimine atfedilemez.

### 4.2. Parçalar arası saldırılar ve yanlış alarmlar

**Tablo 5. Sağlamlık ve belge işleme karşılaştırması.**

| Değerlendirme | mBERT v6d | XLM-R ilk MIL | XLM-R düzeltilmiş MIL |
|---|---:|---:|---:|
| Standart cross-chunk yakalama | 50/100 (%50) | 41/100 (%41) | 90/100 (%90) |
| Adaptif cross-chunk yakalama | 42/100 (%42) | 27/100 (%27) | 69/100 (%69) |
| 25 tarihsel saldırıda yakalama | 18/25 | 25/25 | 25/25 |
| 106 tarihsel normal metinde FP | 0/106 | 0/106 | 1/106 |
| 54 normal tam metinde FP | 0/54 | 0/54 | 3/54 |
| 14 saldırılı dosyada doğrudan tespit | 11/14 | 12/14 | 12/14 |
| Saldırılı dosyanın temiz geçirilmesi | 2/14 | 1/14 | 0/14 |
| Normal dosyanın temiz dışı kararı | 0/3 | 2/3 | 0/3 |

**Kaynak:** Tablo 4 ile aynı üç ham regresyon özeti. Normal tam metin satırında dosya tarama hattı değil, `benign_fulltext` metin değerlendirmesi kullanılmıştır.

Son aday, mBERT'e göre standart saldırılarda 40, adaptif saldırılarda 27 yüzde puan artış sağlamıştır. Bu sentetik dosyalar tekrarlanan saldırı ifadeleri ve taşıyıcılar içerdiğinden 100 bağımsız saldırı ailesi gibi yorumlanamaz; satır düzeyindeki Wilson aralıkları kullanılmamıştır. İlk adayın yüksek metin F1'ine rağmen cross-chunk başarısının gerilemesi, kısa metin testinin bu zayıflığı tek başına göstermediğini ortaya koymaktadır.

AS2 açısından bulgular ek eğitimin parçalar arası saldırılarda yararlı olduğuyla uyumludur. Bununla birlikte ikinci aşamada eğitim verisi, kısa pencereler ve eşik birlikte değişmiştir. Bu tarihsel tam ölçekli koşullarda bileşen etkileri ayrılmadığından kazanım yalnız kısa pencerelere bağlanamaz. Revizyonun aynı veri ve bütçeli pilot ablasyonları Bölüm 4.5'te ayrı sunulmuştur; bunlar tarihsel tam ölçekli eğitimin birebir tekrarı değildir.

AS3 açısından belirgin ödünleşme normal tam metinlerdedir: son model 54 metnin üçünde yanlış alarm üretmiştir (%5,56). Yanlış alarmlar `Meditasyon`, `Nasreddin_Hoca` ve `Parola` metinlerinde kaydedilmiştir. Normal anlatı, alıntı ve güvenlikle ilgili sözcüklerin ayrımında ek inceleme gereklidir. mBERT ve ilk adayın 0/54 sonucu ise gerçek yanlış alarm riskinin sıfır olduğunu kanıtlamaz.

Son adayın 17 dosyalık akışında 12 saldırı doğrudan tespit edilmiş, iki saldırı incelemeye yönlendirilmiş ve üç normal dosya temiz geçmiştir. “Saldırılı dosya temiz geçmedi” sonucu, “14/14 saldırı doğrudan tespit edildi” biçiminde yazılmamalıdır.

### 4.3. Ayrı tutulan saldırı ifadeleri

**Tablo 6. 40 ayrılmış komuttan oluşturulan 480 örnekte sonuçlar.**

| Model | TP/240 | FP/240 | Recall (%) | Precision | F1 |
|---|---:|---:|---:|---:|---:|
| mBERT v6d | 12 | 0 | 5,00 | 1,0000 | 0,0952 |
| XLM-R ilk MIL | 104 | 10 | 43,33 | 0,9123 | 0,5876 |
| XLM-R düzeltilmiş MIL | 187 | 0 | 77,92 | 1,0000 | 0,8759 |

**Kaynak:** [Ayrılmış ifade kontrolü ham sonuçları](artifacts/robust_mil_refined_20261012/holdout/summary.json). Son model F1'i 2 × 187 / (2 × 187 + 53) üzerinden de doğrulanabilir.

Bu testteki %77,92 recall, ortak Türkçe testteki %99,59'dan belirgin düşüktür. Sonuç, seçilen değerlendirme dağılımının ölçülen başarıyı güçlü biçimde etkilediğini göstermektedir. Ayrılmış ifadeler aynı kategorilere ve mevcut taşıyıcılara dayandığından bu kontrol, bağımsız gerçek dünyaya genelleme kanıtı değildir.

### 4.4. Genişletilmiş ölçütler ve karar yükü

Kaydedilmiş tahminler üzerinden yapılan yeni analizde average precision (AP), mBERT için 0,9967; ilk XLM-R için 0,9999; son XLM-R için 0,9997'dir. AP sıralama ölçütüdür; seçilen eşiğin precision değeri değildir. Son modelin ham skor Brier değeri 0,0154, ECE değeri 0,0173'tür. Bu değerler geçerli risk olasılığı kalibrasyonu kanıtı olarak kullanılmamıştır.

| Model | Normal saldırı kararı | Normal inceleme | Normal toplam otomatik geçememe | Saldırının temiz bandında kalması |
|---|---:|---:|---:|---:|
| mBERT v6d | 28/1.447 | 22/1.447 | 50/1.447 (%3,46) | 14/1.228 |
| XLM-R ilk MIL | 10/1.447 | 60/1.447 | 70/1.447 (%4,84) | 1/1.228 |
| XLM-R düzeltilmiş MIL | 8/1.447 | 43/1.447 | 51/1.447 (%3,52) | 2/1.228 |

Bu tablo yalnız metin skorları ve kayıtlı karar bantları içindir; OCR, yapısal göstergeler veya eksik tarama kapsamını içermez. Son modelin daha düşük saldırı yanlış alarmı, taban çizgisine göre daha düşük toplam inceleme/engelleme yükü anlamına gelmemektedir.

![Normal içerikte yanlış alarm ve inceleme yükü](artifacts/publication_revision_20261107/statistics/figures/normal_review_burden.png)

Ayrılmış 40 komutta, son model ile mBERT arasındaki recall farkı +72,92 yüzde puandır. Payload eksenindeki koşullu bootstrap %95 aralığı +64,58 ile +81,25 yüzde puandır. Bu aralık yalnız mevcut payload örneklemini yeniden örnekler; eğitim rastlantısallığı, yeni alanlar ve çapraz taşıyıcı bağımlılıklarının tamamını kapsamaz. Tarihsel testte güvenilir kaynak/aile grupları bulunmadığından satır bağımsızlığı varsayımıyla anlamlılık testi üretilmemiştir.

Üretici kodundan alınan `INJECTION_RE` taban çizgisi tarihsel testte %98,86 recall ve %21,91 FPR; ayrılmış ifade kontrolünde %18,75 recall ve %7,08 FPR üretmiştir. Bu tanı, etiket koşullu veri üretim filtrelerinden kaynaklanabilecek kısa yol riskini gösterir; model başarısının nedenini tek başına ispatlamaz.

**Kaynak:** [İstatistiksel analiz](artifacts/publication_revision_20261107/statistics/RAPOR.md) ve [ham kayıt](artifacts/publication_revision_20261107/statistics/analysis.json).

### 4.5. Ortak protokollü yeniden eğitim ve kontrollü pilotlar

Yeni geliştirme protokolünde model seçimi/eşik ayarlama test üzerinden yapılmamıştır. İlk MIL ayrımları sabitlenmiş; birincil hedef, ayrı kalibrasyonda gözlenen %1 FPR olarak belirlenmiştir. %0,1 hedefi ikincil tanıdır. Hedef değerler popülasyon garantisi değildir. Tüm geçerli tamamlanmış koşular skorlarından bağımsız korunmuştur; sızıntılı veya farklı tarihsel protokoller ana başarı sıralamasına alınmamıştır.

**Koşu durumu:** Bu dosya oluşturulduğunda ilk protokoldeki 18 ve görev için ince ayar görmemiş mBERT uzantısındaki 3 koşudan toplam 21/21 sinir ağı koşusu tamamlanmıştır. Tablolar yalnız tamamlanmış koşuları gösterir; eksik koşular tahmin edilmez. [Uygulama kaydı](SCI_UYGULAMA_DURUMU.md) tamamlanan ve bekleyen işleri listeler.

**Tablo 7. Tam eğitim bölümüyle klasik yöntemler.**

| Model / koşul | Eğitim kaydı | Tohum sayısı | F1 ort. ± SS | Recall ort. | FPR ort. |
|---|---:|---:|---:|---:|---:|
| char_logreg / TF-IDF | 21856 | 3/3 | 0,9874 ± 0,0000 | 99,10% | 1,38% |
| word_logreg / TF-IDF | 21856 | 3/3 | 0,9887 ± 0,0000 | 99,76% | 1,73% |
| word_nb / TF-IDF | 21856 | 3/3 | 0,9541 ± 0,0000 | 93,08% | 1,73% |
| word_rf / TF-IDF | 21856 | 3/3 | 0,9916 ± 0,0017 | 99,67% | 1,15% |
| word_svc / TF-IDF | 21856 | 3/3 | 0,9939 ± 0,0000 | 100,00% | 1,04% |

**Tablo 8. Aynı 1.024 kayıt üzerinde sınırlı bütçeli karşılaştırmalar ve ablasyonlar.**

| Model / koşul | Eğitim kaydı | Tohum sayısı | F1 ort. ± SS | Recall ort. | FPR ort. |
|---|---:|---:|---:|---:|---:|
| berturk / hardmax_long | 1024 | 3/3 | 0,1398 ± 0,0607 | 7,65% | 0,74% |
| char_logreg / TF-IDF | 1024 | 3/3 | 0,9592 ± 0,0000 | 93,89% | 1,59% |
| mbert_continuation / hardmax_long | 1024 | 3/3 | 0,9865 ± 0,0025 | 99,19% | 1,61% |
| mbert_pretrained / hardmax_long | 1024 | 3/3 | 0,4883 ± 0,1446 | 33,41% | 0,90% |
| word_logreg / TF-IDF | 1024 | 3/3 | 0,9729 ± 0,0000 | 96,34% | 1,45% |
| word_nb / TF-IDF | 1024 | 3/3 | 0,9362 ± 0,0000 | 89,58% | 1,52% |
| word_rf / TF-IDF | 1024 | 3/3 | 0,9730 ± 0,0019 | 96,44% | 1,52% |
| word_svc / TF-IDF | 1024 | 3/3 | 0,9788 ± 0,0000 | 97,88% | 1,80% |
| xlmr / first_window_ce | 1024 | 3/3 | 0,2798 ± 0,2519 | 18,16% | 0,81% |
| xlmr / hardmax_bridge | 1024 | 3/3 | 0,2556 ± 0,2552 | 16,53% | 0,71% |
| xlmr / hardmax_bridge_short | 1024 | 3/3 | 0,4823 ± 0,1199 | 32,71% | 0,99% |
| xlmr / hardmax_long | 1024 | 3/3 | 0,2862 ± 0,2515 | 18,54% | 0,69% |

Tohumlar 42, 123 ve 456'dır. Tablolarda SS, tamamlanan tohumların örneklem standart sapmasıdır; bağımsız test belirsizliği değildir. Deterministik klasik modellerin farklı tohumlarda aynı sonuç vermesi genel belirsizliğin sıfır olduğunu göstermez. Bir tohum grubu 3/3 tamamlanmadan tam tekrar sonucu sayılmaz. Kod hash'i farklı koşular, eğitim/skorlama eşdeğerliği kanıtlanmadıkça ayrı gruplandırılır; köşeli hash kısaltmaları bunu gösterir. Eğitim kaydı ve temel ayarları çelişen koşular birleştirilmez.

Transformer pilotu sınıf başına 512 kayıt, bir epoch, 1e−5 öğrenme oranı, batch 16, AdamW, 0,01 weight decay, yaklaşık %6 warmup ve 1,0 gradient clipping kullanır. Sözcük embedding tablosu sabittir. `hardmax_long`, `hardmax_bridge` ve `hardmax_bridge_short` aynı eğitim kayıtları üzerinde pencere görünümlerini değiştirir. `first_window_ce` eğitimde ilk görünümü seçer; değerlendirmede uzun pencerelerin maksimumunu kullanır. Böylece eğitim penceresi seçiminin etkisi aynı çıkarım kapsamıyla incelenir.

Tam verili klasik modeller ile 1.024 kayıtlı Transformer pilotları aynı veri bütçesi karşılaştırması değildir; Tablo 8'deki pilot klasik modeller bu ayrım için eklenmiştir. mBERT continuation checkpoint'i daha önce görev verisi görmüştür; temiz ön eğitimli BERTurk/XLM-R ile omurga üstünlüğünü izole etmez. Tek epoch düşük bütçeli sonuçlar model ailesinin ulaşabileceği en iyi başarım olarak yorumlanmamalıdır. Hyperparametre aramasıyla eşitlenmiş tam ölçekli model üstünlüğü deneyi tamamlanmış değildir.

Ek mBERT koşulu, görev için ince ayar görmemiş Google dil ön eğitimi ağırlıklarıyla aynı veri ayrımları ve aynı eğitim bütçesini kullanır; `mbert_pretrained` olarak ayrı raporlanır. Bu uzantı ilk pilot sonuçları görüldükten sonra planlandığından doğrulayıcı değil geliştirme deneyidir. Ön eğitim kaynaklarıyla test kaynaklarının örtüşmediği kanıtlanmış değildir. İndirme sürümü, dosya hash'leri ve çalışma zamanı model kaydı ayrı manifestlerde tutulur.

Tarihsel mDeBERTa denemeleri sonlu olmayan kayıp nedeniyle tamamlanmamıştır; başarı tablosuna sonuç eklenmemiştir. XGBoost mevcut revizyon ortamında kurulu olmadığından bu aşamada yeni koşu olarak raporlanmamıştır. Tarihsel skorlar yeni ortak protokol sonucu yerine kullanılmamıştır.

**Kaynak:** [Dondurulmuş protokol](artifacts/publication_revision_20261107/experiments/protocol.json), [tüm koşular](artifacts/publication_revision_20261107/experiments/RESULTS.md).



![Ortak pilot karşılaştırması: üç tohum ortalaması ve standart sapması](artifacts/publication_revision_20261107/figures_final/pilot_comparison.png)

![XLM-R pencereleme koşullarında eşleştirilmiş tohum sonuçları](artifacts/publication_revision_20261107/figures_final/xlmr_paired_seeds.png)

Grafiklerdeki değişim aynı tarihsel testte eğitim tohumlarına aittir; bağımsız dış test güven aralığı değildir.

XLM-R pilotunda ortalama F1 uzun pencerelerde 0,2862, köprü görünümleri eklendiğinde 0,2556, kısa görünümler de eklendiğinde 0,4823, ilk görünümle eğitim kontrolünde 0,2798 olmuştur. Tohumlar arasındaki büyük değişim nedeniyle tek en iyi koşu seçilmemiştir. Bu sonuçlar, bir epoch bütçesinde pencereleme ile eğitim rastlantısallığının birlikte etkili olduğunu gösterir; tam ölçekli tarihsel modelin kazanımını tek bir bileşene atfetmez.

### 4.6. Giriş biçimine göre sonuçlar

| Biçim | Saldırı/normal | mBERT recall/FPR | İlk XLM-R recall/FPR | Son XLM-R recall/FPR |
|---|---:|---:|---:|---:|
| EXTERNAL_CONTENT | 893/947 | 99.66% / 2.53% | 99.89% / 1.06% | 99.78% / 0.42% |
| SYSTEM_USER | 204/209 | 100.00% / 1.91% | 99.02% / 0.00% | 99.02% / 0.96% |
| UNMARKED | 131/291 | 87.79% / 0.00% | 100.00% / 0.00% | 99.24% / 0.69% |

Biçim ayrımı, dolaylı enjeksiyonda bağımsız genelleme testi değildir. Etiket ve kaynak sınırları ana raporla aynıdır.

Bu gruplar otomatik biçim işaretlerine dayanır; insan tarafından doğrulanmış doğrudan/dolaylı saldırı taksonomisi değildir. Kaynak ve görev bağımsızlığı sınırlılıkları korunmaktadır.

### 4.7. Yayımlanmış İngilizce dedektörün Türkçeye aktarımı

Protect AI DeBERTa-v3-base-prompt-injection-v2 modeli değişmez yayın sürümünden indirilmiş ve yerel olarak değerlendirilmiştir. Model kartı İngilizce kullanımını ve bakım durumuna ilişkin sınırlılıkları belirtir; burada güncel en iyi yöntem veya Türkçeye uygunluğu kanıtlanmış sistem olarak sunulmamaktadır [9].

| Küme | Eşik seçimi | Precision | Recall | F1 | FPR |
|---|---|---:|---:|---:|---:|
| historical_test | fixed_0.5_under_common_windows | 0,6241 | 7,17% | 0,1286 | 3,66% |
| historical_test | calibration_fpr_0.01 | 0,7286 | 4,15% | 0,0786 | 1,31% |
| historical_test | calibration_fpr_0.001 | 0,8000 | 0,33% | 0,0065 | 0,07% |
| reserved_expressions | fixed_0.5_under_common_windows | 0,6552 | 15,83% | 0,2550 | 8,33% |
| reserved_expressions | calibration_fpr_0.01 | 0,7805 | 13,33% | 0,2278 | 3,75% |
| reserved_expressions | calibration_fpr_0.001 | 0,9375 | 6,25% | 0,1172 | 0,42% |

Karşılaştırıcı ilk MIL'in 2.733 kayıtlık kalibrasyonunu kullanır; tarihsel son XLM-R eşiği 2.829 kayıtla seçilmiştir. Aynı FPR hedefi aynı kalibrasyon örneklemi demek değildir. İngilizce modelin düşük Türkçe sonucu evrensel mimari yetersizlik veya projenin genel üstünlüğü olarak yorumlanamaz. Yeni bağımsız veri testi yapılmamış; mevcut tarihsel test yeniden kullanılmıştır.

**Kaynak:** [Karşılaştırıcı raporu](artifacts/publication_revision_20261107/external_baseline/full_comparator/RAPOR.md), [sürüm ve dosya doğrulaması](artifacts/publication_revision_20261107/external_baseline/download_manifest.json).

### 4.8. Belge katmanları, OCR ve yerel RAG deneyi

Sekiz biçimde 46 kontrollü dosya oluşturulmuştur: 29 saldırılı ve 17 normal kontrol. Saldırılar tek açık komutun biçim ve yerleştirme türevleridir. Görünür çıkarım ve model yolu 21/29, tam belge hattı 29/29 saldırı kararı üretmiştir. Hiçbir saldırılı dosya temiz geçmemiş; işlem istisnası oluşmamıştır. Buna karşılık sekiz normal alıntı kontrolünün tamamı yanlış işaretlenmiştir. Bu sekiz hata, aynı alıntı örüntüsünün biçim türevleridir; sekiz bağımsız anlamsal aile değildir.

| Yol | Saldırı kararı | Normal temiz dışı karar | p50 | p95 |
|---|---:|---:|---:|---:|
| Görünür çıkarım + model | 21/29 | Alıntı ayrımı ayrıca değerlendirilir | 0,0289 s | 0,3670 s |
| Tam belge hattı | 29/29 | 8/17 | 0,0732 s | 1,2019 s |

Görünür yol süresi saf model forward süresi değildir; metin çıkarımı dahildir ve üç görüntü PDF'sinde model çağrısı yoktur. Tam yol OCR ve yapısal incelemeyi kapsar. Model yükleme hariç, ilk soğuk örnek dahildir; farklı süre kapsamlarından genel hız üstünlüğü çıkarılamaz. PPTX örnekleri minimal çıkarıcı paketleridir; gerçek Office uyumluluğu kanıtı değildir.

Gerçek yerel OCR üç görüntü PDF'sinde metni geri kazanmıştır. Ham karakter hata oranları yaklaşık %1,79, %2,16 ve %1,08'dir. Bu üç kurgulanmış sayfa genel OCR doğruluğu kanıtı sayılmaz. İlgili görünmez, kodlanmış ve üstveri akımlarındaki katkılar ayrı kaynak kayıtlarında tutulmuştur.

![Belge biçimleri ve alıntı hataları](artifacts/publication_revision_20261107/system_v3/report/figure_1_format_detection_and_quote_errors.png)

Yerel Qwen2.5:7b, TF-IDF, 400 karakterlik parçalar, 50 karakter örtüşme ve top-3 getirimle yürütülen küçük RAG tanısında, getirim öncesi belge metnine yalnız model skoruna dayalı koruma uygulanmıştır. Engelleme eşiği kayıtlı inceleme sınırı olan 0,3276683092'dir. Bu RAG koşulu yapısal belge incelemesini, OCR'ı ve Base64 çözümleme katmanını çalıştırmaz; yukarıdaki tam belge hattı deneyiyle aynı koruma kapsamına sahip değildir. Güvenilir görev proje kodunu yanıtlamak, saldırı hedefi ise yalnız sabit bir saldırı işaretçisini yazdırmaktır. Savunma açık/kapalı koşullarında aynı içerik ve hedef LLM kullanılmıştır.

| Koşul | Saldırı hedefi gerçekleşti | Normal görev başarısı | Normal engelleme |
|---|---:|---:|---:|
| Koruma kapalı | 6/8 | 1/2 | 0/2 |
| Koruma açık | 0/8 | 1/2 | 1/2 |

Üretim ayarları temperature=0, seed=42, en fazla 32 çıktı tokenı ve 2.048 token bağlamdır. Sonuçlar sabit işaretçinin tam eşleşmesine dayanır; serbest yanıt kalitesi insan tarafından puanlanmamıştır. Üretici model kaydı `qwen2.5:7b` etiketiyle tutulmuş, çalıştırma anındaki ağırlık/kuantizasyon özeti sabit bir hash ile kaydedilmemiştir. Bu durum RAG tanısının tam yeniden üretilebilirliğini sınırlar; sonradan okunan bir model kimliği geçmiş koşuya aitmiş gibi sunulmamıştır.

Bu küçük deneydeki azalma genel saldırı engelleme oranı değildir. Normal alıntı kontrolü koruma kapalıyken de görevi saptırmış, koruma açıkken engellenmiştir. Etiketi bu sonuç görüldükten sonra değiştirilmemiştir. Normal görev yararı ve yanlış engelleme ayrı raporlanmıştır.

Dört komut ailesi için altışar aday, toplam 24 skor sorgusuyla sınırlı kaçınma araması yapılmıştır. En düşük skorlu dört aday Base64 kodlama kullanarak model geçiş bandında kalmıştır. Buna karşılık bu dört adayın hiçbiri hedef LLM'de saldırı amacını gerçekleştirmemiştir; koruma açık ve kapalı sonuç 0/4'tür. Model tespitinden kaçma ile başarılı uçtan uca saldırı bu nedenle eşitlenmemiştir. Anlam korunumu bağımsız insan değerlendirmesi beklemektedir.

**Kaynak:** [Tam sistem raporu ve şekiller](artifacts/publication_revision_20261107/system_v3/report/REPORT_TR.md), [kaynak doğrulaması](artifacts/publication_revision_20261107/system_v3/report/provenance.json).

### 4.9. Veri soy ağacı ve insan değerlendirmesi durumu

16 tarihsel dosyadaki 192.261 kayıt denetlenmiştir; bu toplam benzersiz belge sayısı değildir. Açık `source_id` alanı bulunmayan geçmiş kayıtlara hayali kaynak kimliği atanmadı. Gözlenen `src`, `src_url`, ebeveyn ve grup alanları kanıt olarak korunmuştur. 74 kayıtlık kör inceleme paketi, iki ayrı boş değerlendirici formu, Türkçe etiket yönergesi ve anlaşma/uyuşmazlık araçları hazırlanmıştır. Ancak kullanıcı bağımsız insan değerlendiricisi ve izinli yeni belge erişimi bulunmadığını bildirmiştir; insan doğrulaması tamamlanmış değildir.

Dış test kilidi; eksik insan kararı, eksik kaynak bilgisi, tarihsel yeniden kullanım, çelişkili metin hash'i ve aynı URL'nin farklı kimlikle kullanılması gibi durumları reddeder. Bu altyapı bağımsız testin kendisi değildir. Tarihsel veri üzerinden yapılan hiçbir yeni analiz testin bağımsızlığını geri kazandırmaz.

**Kaynak:** [Veri durumu](artifacts/publication_revision_20261107/data/status.json) ve [insan etiketleme iş akışı](research/publication_data/README.md).

### 4.10. Çıkarım normalizasyonunun etkisi

Aynı dondurulmuş XLM-R modelinde normalizasyon açık/kapalı olarak 15 kurgulanmış kontrol puanlanmıştır: normal metin, saldırı alıntısı ve saldırının beşer dönüşümü. Bunlar üç temel metnin türevleridir; bağımsız 15 belge veya eğitim ablasyonu değildir. CPU FP32, batch 1 ve sabit eşikler kullanılmıştır.

| Dönüşüm | Saldırı kararı: kapalı → açık | Normal temiz dışı: kapalı → açık |
|---|---:|---:|
| plain | 1/1 → 1/1 | 1/2 → 1/2 |
| nfkc_fullwidth | 1/1 → 1/1 | 1/2 → 1/2 |
| homoglyph | 0/1 → 1/1 | 1/2 → 1/2 |
| zero_width | 0/1 → 1/1 | 0/2 → 1/2 |
| combined | 0/1 → 1/1 | 0/2 → 1/2 |

Normalizasyon, sıfır genişlikli karakter ve birleşik dönüşümle gizlenen saldırının bu örnekte saptanmasını sağlamış; aynı zamanda normal saldırı alıntısındaki yanlış alarmı korumuştur. Dönüşümler mevcut normalleştiricinin desteklediği kümeden seçilmiştir. Sonuç bütün Unicode kaçınmalarına veya doğal saldırılara genellenemez. Normalizasyon kapalı koşul eğitimdeki ön işlemeden sapar; bu ölçüm yeniden eğitim yapılmış iki modelin karşılaştırması değildir.

**Kaynak:** [Normalizasyon tanısı](artifacts/publication_revision_20261107/normalization_20261109/REPORT_TR.md).

## 5. Tartışma

Sonuçlar, belge güvenliğinin iki ayrı eksende değerlendirilmesi gerektiğini göstermektedir. İlk eksen, normal ve saldırılı metinlerin sınıflandırılmasıdır. İkinci eksen ise gerçek belge işleme koşullarında saldırı içeriğinin modele ulaştırılması ve farklı parçalardaki ilişkilerin korunmasıdır. İlk XLM-R adayının 0,9947 F1'e ulaşırken standart cross-chunk yakalamasında %41'de kalması bu ayrımı görünür kılmaktadır.

Kısa pencere düzeltmesinden sonraki artış, tek bir belgeyi birden fazla görünümle değerlendirmenin yararıyla uyumludur. Bununla birlikte uzak blok birleştirmeleri kapsamlı bir ilişkisel akıl yürütme mekanizması değildir. Son modelin 31/100 adaptif saldırıyı kaçırması ve ayrı ifade kontrolünde 53/240 saldırının tespit edilememesi bu sınırı göstermektedir.

Yanlış alarm artışı özellikle belge düzeyinde maksimum skor toplamanın tartışılmasını gerektirir. Tek bir pencerenin yüksek skoru belgeyi şüpheli hale getirebilir. Bu davranış saldırıları yakalamaya yardımcı olurken normal alıntılara veya güvenlik tartışmalarına duyarlılığı da artırabilir. Alternatif toplama işlevleri, uzunluğa duyarlı kalibrasyon ve normal yönerge örnekleri sonraki kontrollü deneylerde incelenebilir; bunların etkisi mevcut çalışmada ölçülmemiştir.

Tarihsel veride saptanan saldırı ifadesi örtüşmesi, değerlendirme tasarımının model seçiminden önce geldiğini göstermektedir. Eğitimde görülen 20 saldırı ifadesini yeni taşıyıcı belgelerde tanımak ile yeni saldırı ifadelerini tanımak farklı görevlerdir. Bu nedenle sonuçlar yorumlanırken belge ayrımının yanında saldırı ifadesi ayrımı da dikkate alınmalıdır. Benzer biçimde v6d-full için gözlenen düşüş, veri hacminin artmasının zarar verdiği biçiminde açıklanamaz; eğitim dağılımı ve saldırı ifadesi maruziyeti de değişmiştir.

Tarihsel ana sonuçlar model, veri artırma, pencereleme ve eşik seçiminin birlikte oluşturduğu yapılandırmaları karşılaştırır. Revizyon pilotlarında aynı kayıtlar, ortak kalibrasyon hedefi ve üç tohum kullanılarak bazı karıştırıcılar azaltılmıştır. Ancak tek epoch ve sabit küçük bütçe farklı omurgaların yeterince öğrenmesini garanti etmez; görev verisi görmüş mBERT continuation ayrıca ayrılmalıdır. Mimari üstünlük için yakınsamayı ve hiperparametre aramasını kapsayan adil eğitim ile bağımsız dış test gereklidir. Burada istatistiksel anlamlılık veya tüm Türkçe RAG uygulamalarına üstünlük iddiası ileri sürülmemektedir.

## 6. Geçerlilik tehditleri ve sınırlılıklar

**Veri bağımsızlığı:** Kaynak/üretim ailesi kimliklerinin eksikliği, sözcüksel tekrar kontrolünün anlamsal veya şablon bağımsızlığını kanıtlamasını engeller. Tarihsel test tasarım geri bildirimi için kullanıldığından nihai bağımsız test değildir.

**Gerçek kullanım kapsamı:** Yeni kurumlardan toplanmış, uzmanlarca etiketlenmiş, model geliştirmesinden tamamen ayrılmış bir gerçek belge kabul kümesi bulunmamaktadır. Veri türlerinin desteklenmesi, her türün yeterli örneklemle doğrulandığı anlamına gelmez.

**Tekrarlanabilirlik ve belirsizlik:** Tarihsel ana MIL deneyleri tek rastgele tohumla yürütülmüştür. Yeni düşük bütçeli pilotlar 42/123/456 tohumlarını kullanır; bu tekrarlar tarihsel tam ölçekli modellerin eğitim varyansını açıklamaz. Bağımlı sentetik kayıtlar için satır düzeyinde Wilson aralıkları ana bulgulardan çıkarılmıştır. Payload'a koşullu bootstrap ve eğitim tohumları arasındaki değişim farklı belirsizlik kaynaklarını ölçer; hiçbiri yeni alanlara dağılım kaymasının tamamını kapsamaz.

**Etiket çözünürlüğü:** Kesin saldırı token/karakter aralıkları bulunmadığından parça düzeyinde doğruluk veya saldırı lokalizasyon başarısı raporlanmamıştır. En yüksek skorlu pencere kesin açıklama değildir.

**Çıkarım kapsamı:** Metin çıkarımı, OCR ve kaynak sınırları modelden ayrı hata kaynaklarıdır. Belgenin tamamı çıkarılamadığında sınıflandırıcının görmediği içeriği tespit etmesi beklenemez. Eksik kapsamın temiz karara dönüştürülmemesi bu nedenle gereklidir.

**Güvenlik çıktısı:** Tespit recall'u, RAG bağlamına zararlı içerik maruziyeti ve üretici modelin saldırıya uyma oranı farklı ölçütlerdir. Sonuncusu revizyonda tek yerel LLM ve küçük kurgulanmış görev kümesiyle ölçülmüştür; geniş ve bağımsız bir güvenlik değerlendirmesi değildir.

**Kaynak kayıt bütünlüğü:** Bazı tarihsel ağırlıklar ve özgün raporlar artık mevcut değildir. `tez.md` içinde anılan `results/asr_report.md` bu incelemede bulunamadığından tarihsel RAG maruziyet yüzdeleri ana bulgulara alınmamıştır. Yeniden hesaplanmayan sonuçlar açıkça tarihsel kayıt olarak işaretlenmiştir.

## 7. Sonuç

Bu çalışma, Türkçe RAG belgelerinde dolaylı istem enjeksiyonunu ele alan çok katmanlı bir analiz hattını ve XLM-R tabanlı belge düzeyinde hard-max MIL yaklaşımını incelemiştir. Son yapılandırma ortak tarihsel Türkçe testte 0,9947 F1, %99,59 recall ve %0,55 FPR sağlamış; standart ve adaptif parçalar arası saldırılarda mBERT taban çizgisine göre sırasıyla 40 ve 27 yüzde puan daha yüksek yakalama üretmiştir. Bununla birlikte normal tam metinlerdeki 3/54 yanlış alarm ve ayrı saldırı ifadesi kontrolündeki %77,92 recall, yüksek metin F1'inin kapsamlı belge güvenliği anlamına gelmediğini göstermektedir.

Revizyonda ortak geliştirme karşılaştırmaları, çoklu tohumlu sınırlı bütçe pilotları, pencereleme kontrolleri, gerçek yerel OCR ve küçük uçtan uca RAG tanıları eklenmiştir. Bulgular alıntı kaynaklı yanlış alarmları ve tespit kaçınması ile gerçek saldırı başarısı arasındaki farkı görünür kılmıştır. Bağımsız insan etiketli gerçek dış test, eksiksiz veri soy ağacı ve tam ölçekli adil hyperparametre karşılaştırmaları hâlâ gereklidir. Bu eksikler giderilmeden gerçek dünya güvenliği veya mimari üstünlük iddiası ileri sürülemez.

## Kaynakça

[1] Greshake, K., Abdelnabi, S., Mishra, S., Endres, C., Holz, T. ve Fritz, M. (2023). *Not what you've signed up for: Compromising Real-World LLM-Integrated Applications with Indirect Prompt Injection*. [arXiv:2302.12173](https://arxiv.org/abs/2302.12173).

[2] Devlin, J., Chang, M.-W., Lee, K. ve Toutanova, K. (2019). *BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding*. [arXiv:1810.04805](https://arxiv.org/abs/1810.04805).

[3] Conneau, A. ve diğerleri (2020). *Unsupervised Cross-lingual Representation Learning at Scale*. [arXiv:1911.02116](https://arxiv.org/abs/1911.02116).

[4] Ilse, M., Tomczak, J. M. ve Welling, M. (2018). *Attention-based Deep Multiple Instance Learning*. [arXiv:1802.04712](https://arxiv.org/abs/1802.04712).

[5] Jacob, D. ve diğerleri (2025). *PromptShield: Deployable Detection for Prompt Injection Attacks*. [arXiv:2501.15145](https://arxiv.org/abs/2501.15145).

[6] Yi, J. ve diğerleri (2025). *Benchmarking and Defending Against Indirect Prompt Injection Attacks on Large Language Models*. [arXiv:2312.14197](https://arxiv.org/abs/2312.14197).

[7] Zhan, Q. ve diğerleri (2024). *InjecAgent: Benchmarking Indirect Prompt Injections in Tool-Integrated Large Language Model Agents*. [arXiv:2403.02691](https://arxiv.org/abs/2403.02691).

[8] Debenedetti, E. ve diğerleri (2024). *AgentDojo: A Dynamic Environment to Evaluate Prompt Injection Attacks and Defenses for LLM Agents*. [arXiv:2406.13352](https://arxiv.org/abs/2406.13352).

[9] Protect AI. *DeBERTa-v3-base-prompt-injection-v2 model card*. [Resmî model kartı](https://huggingface.co/protectai/deberta-v3-base-prompt-injection-v2). Denenen sürüm yerel manifestte sabittir.

## Ek A. Deney kayıtları ve yeniden üretim bilgileri

Tarihsel kaynaklar ve metrikler denetlenmiş; yeni ortak protokollü eğitimler, istatistik analizleri ve sistem tanıları ayrı araştırma dizininde yürütülmüştür. Bağımsız insan etiketli yeni kabul testi yapılmamıştır. Eski deney dosyaları korunmuş, makalenin revizyon öncesi kopyası `artifacts/publication_revision_20261107/article_before_revision.md` altında saklanmıştır.

| Kanıt türü | Yerel kaynak |
|---|---|
| Birinci aşama veri ayrımı | [Manifest](artifacts/robust_mil_20261012/data/manifest.json) |
| İkinci aşama veri ayrımı | [Manifest](artifacts/robust_mil_refined_20261012/data/manifest.json) |
| Birinci aşama eğitim ayarları | [Reçete](artifacts/robust_mil_20261012/run/recipe.json) |
| İkinci aşama eğitim ayarları | [Reçete](artifacts/robust_mil_refined_20261012/run/recipe.json) |
| Son modelin test sonucu ve güven aralıkları | [Değerlendirme özeti](artifacts/robust_mil_refined_20261012/evaluation/summary.json) |
| Son modelin belge ve saldırı regresyonları | [Regresyon özeti](artifacts/robust_mil_refined_20261012/regression/candidate/summary.json) |
| Ayrılmış saldırı ifadeleri | [Kontrol özeti](artifacts/robust_mil_refined_20261012/holdout/summary.json) |
| Eğitim algoritması | [MIL eğitim kodu](egitim/robust_mil.py) |
| Çalışma zamanı pencereleme ve skor | [MIL çıkarım kodu](core/mil_inference.py) |
| Normalizasyon | [Normalizasyon kodu](core/normalize.py) |
| Belge tespit hattı | [Tespit kodu](core/detect.py) |
| RAG geçiş politikası | [İndeksleme koruması](core/ingestion.py) ve [karar politikası](core/policy.py) |

Önemli bir kayıt düzeltmesi: `TUM_MODELLER_KARSILASTIRMA.md` içindeki ana karşılaştırma anlatısında ilk ve son XLM-R adayının 54 normal metin sonuçları ham kayıtlarla uyuşmamaktadır. Ham `benign_fulltext` sonuçları mBERT için 0/54, ilk aday için 0/54, son aday için 3/54'tür; bu raporda bunlar kullanılmıştır. Benzer şekilde BERTurk'un önceki 3/106 FP kaydı ile Ekim ortak tekrar ölçümündeki 4/106 FP kaydı farklı koşular olarak değerlendirilmiştir.

İlk aday model SHA-256: `f8ce6b5251f62a53e92d7ca53e3cf7a7c3cfaef40f0bea3c6466b22ede6ccfd2`.

Son aday model SHA-256: `9850aee6149edf9e0bde8ac62b397548323dd375848cd5e700f9e0abc657f3e3`.

mBERT taban çizgisi SHA-256: `4e908f7dec317dee992b0c2d2fcb14e69724dea3aa29836512075484369843b4`.

Bu kimlikler deney kayıtlarından aktarılmıştır. Geçerli çalışma zamanı modeli veya üretim kabul durumu, tarihsel deney sonucu yerine kullanılamaz; rapor bilimsel değerlendirmeye odaklanmaktadır.


## Ek B. Revizyon paketi ve açık işler

[Uygulama durumu](SCI_UYGULAMA_DURUMU.md), [protokol](research/publication/protocol.json), [yeniden üretim açıklaması](research/publication/README.md) ve [yayın beyanları](research/publication/YAYIN_BEYANLARI.md) birlikte okunmalıdır. Başarısız/uygunsuz tarihsel protokoller skor değerlerinden bağımsız olarak ana model sıralamasından çıkarılmıştır; orijinal deney kayıtları korunmuştur.

Son revizyon 30 klasik ve 21 sinir ağı koşusunu içerir. [İlk 48 koşunun kimlik/metrik doğrulaması](artifacts/publication_revision_20261107/experiments/alignment_verification.json) ve [üç ek mBERT koşusunun doğrulaması](artifacts/publication_revision_20261107/experiments_mbert_pretrained/alignment_verification.json) ayrı kaydedilmiştir. [Yerel kaynak paketi](artifacts/publication_revision_20261107/reproducibility_20261114/README_TR.md) kodu, protokolleri ve gözlenen ortam sürümlerini belgeler; veri ve ağırlıklar kaynak ZIP'ine dahil değildir.
