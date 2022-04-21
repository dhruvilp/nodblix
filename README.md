# Nodblix

### Contributers and Contact Information:

1. Mudra Patel (Github @mudrap): Graduate student in Pharmacy
2. Dhruvil Patel (Github @dhruvilp): Full-stack software engineer


### Problem Statement Addressed: 
    4. Find Novel Drug Treatments

### Inspiration: 

Drugs and other medical treatments are approved in carefully controlled clinical trials that are designed to answer very narrow questions about the safety and efficacy of those treatments for very specific conditions and patient groups. However, treatments are often effective for a wider range of uses than what they are officially approved for. Such “off label” usage is common.

Off-label prescribing isn't necessarily bad. It can be beneficial, especially when patients have exhausted all other approved options, as may be the case with rare diseases or cancer. According to the American Cancer Society, cancer treatment often involves using certain chemotherapy drugs off-label, because a chemotherapy drug approved for one type of cancer may actually target many different types of tumors. Off-label use of a drug or combination of drugs often represents the standard of care.

The US Centers for Medicare and Medicaid Services publishes a lot of public use data about healthcare in the United States. These data sets contain information about drugs prescribed and conditions treated. The data is not individually identifiable, but can be related through providers and facilities. This data could be linked to understand potential off label uses of existing treatments by identifying cases where drugs are being prescribed by providers or at facilities that don’t treat the primary use. Using this approach could allow us to generate new medical knowledge from the full healthcare system and not just from clinical trials.

### What It Does:

Applied to pharmaceutical research, a graph like Nodblix provides a framework to take advantage of huge libraries of prospective drugs and isolate which compounds could be functionally relevant. Tiger Graph allowed us to model biological complexity in detail and thereby will make drug discovery more efficient and economical for researchers and medical professionals. The Nodblix graph depicts a bidirectional relationship between drug compounds and their usages for various health conditions, with vertices representing condition, intervention, age, gender, phase, location, and study. Here, edges will be bidirectionally pointing from intervention to condition, with a directed path from condition to age, gender, phase, location, and research. Depending on the user's input, the Nodblix graph will stretch from intervention to drug or vice versa.

Leveraging graph analytics approaches can provide a powerful accelerator to complex data structure representations and speed understanding of complex relationships between drugs, symptoms, genes, diseases and more, acting as a catalyst to identify opportunities. Applied to pharmaceutical research, a graph like Nodblix provides a framework to take advantage of huge libraries of prospective drugs and isolate which compounds could be functionally relevant. Tigergraph allowed us to model biological complexity in detail and thereby will make drug discovery more efficient and economical for researchers and medical professionals.

#### Impactfulness:
Our solution, Nodblix, will help medical professionals discover potential medical treatments for their patients from one million choices available out in the market. To treat a common cold, a doctor has a few well known options he can choose from. Choosing the right drug here is routine for him. But a lot of situations are more complex. To treat the patient, he may have to combine different drugs. Combining them could be dangerous though, he has then to anticipate how they are going to interact. Furthermore, the patient may have special traits. The doctor has to consider their impact : pregnancy, allergy, age, condition. Choosing a treatment involves a deep understanding of the connections between drugs and patients. Making a good decision here is literally a matter of life and death. Thankfully, graph technologies can help. They make it easy to analyze the connections in complex datasets to provide clear answers. Nodblix will indeed help pharmaceutical institutions to save a lot of money on hosting trials to find common patterns between drugs they have manufactured.

#### Innovativeness:
Our frame design will minimize the complexity of the data as we are using a graph to represent our data. Nodblix will depict a bidirectional relationship between medications and their use in various conditions, with vertices representing condition, intervention, age, gender, phase, location, and study. Our edges will be bidirectionally pointing from intervention to condition, with a directed path from condition to age, gender, phase, location, and research. Depending on the user's input, our graph will stretch from intervention to drug or vice versa. For example, selecting specific conditions will expand age, gender, location, phase, and study information pertaining with this. Graph schema will minimize the complexity of the data because it lines up the vertices and edges perfectly which result in clear mapping of the data. 

#### Ambitiousness:
Using drugs appropriately is both hard and dangerous. It involves understanding complex interactions between health conditions and drug compounds. Nodblix is a carefully designed graph to find patterns between off-label drug usage data. The solution schema is about 8 KB (compressed file). In addition, there are about 80k vertices and 45k edges between them. Entity types include: condition (health condition), intervention_1 (drug compound), trial (trial data), people, etc. Tiger graph instance has some GSQL queries that can be run within Tigergraph. Additionally, Nodblix also has a web app for general interest and people who are not much familiar with the graph database or technology in general.  The Nodblix web app also provides additional information on health conditions and drug compounds via Wikipedia for information only purposes.

#### Applicability:
HOW used in other industries/HOW many industry adopt solution & HOW big industry is: 
- **Stock Market**:
 
    Find patterns in the stock market, for instance, you check the connection of how many people buy the same stock, how often they buy, and that will help the market learn the pattern. Also, check to see how many people tend to buy similar multiple stocks and that will help figure out similar interests that people have. 
Focus Population: effect industrial company, stock broker  
- **Library**:
 
    The solution can be used in the libraries to sort the books based on need popularity and the online system will help better categorize books on shelf by finding connections between the stories and subjects. 
Focus Population: Student, librarians, researchers, professors, teachers
- **Chemical/Chemistry industry**:

    It is useful in the chemical industry as it helps understand how chemicals are related and how a chemical is capable of making multiple compounds, which can be understood by checking combinations between its properties.
Focus Population: Health companies, researchers, student, professors

HOW easy to put on real world:

Anyone interested in utilizing Nodblix can simply adapt the global graph schema and expand upon it. Tiger graph is a very friendly solution when it comes to trying things differently and adopting new strategies as wished to do so.


### Challenges We Ran Into
As a new developer starting from using a TigerGraph to writing code was challenging for me, however, the resources provided were easy to follow which helped us a lot. Additionally, making connections for mapping was a little challenging as a first time user, however, the introduction video helped us understand the logical use of the Graph. 

### Accomplishments That We're Proud Of
We are proud of the outcome of our results, where we were able to expand multiple connections between condition and intervention as expected. Additionally, our secondary expansion was logically expanded from specific conditions to age, gender, condition, location of a specific study they are associated with. 

### What's Next for Nodblix
Looking to the future, the Nodblix project is expected to expand into the medical industry for wider use, in addition to being effective in several other industries which is further categorized in the Applicability section.

For instance, to further expand in the healthcare field, you can add therapies, surgeries, biotechnologies used to treat the diseases. For genomic use we can include amino acids, protein chains that affect the body in various ways. DNA and RNA help us learn patterns and understand pathogens and their causative conditions. We can also use it to understand pharmacokinetics and pharmacodynamics - where drugs have unknown effects on the body that were not potentially studied when it came on market but further studies concluded the off-set effect of those drugs on the body and how the body reacts to them because sources are not openly available for doctors to help. 


Submission video link: 

### Other additions: 

 - **Data**: CDC Clinical Trial Results online https://clinicaltrials.gov/ct2/results 
 - **Technology Stack**: Tigergraph DB, Flutter, Dart, Python, GSQL 
 - **Visuals**: Feel free to include other images or videos to better demonstrate your work.
 - **Tigergraph**: https://nodblix.i.tgcloud.io/ (raise a github issue to get access)
 - **Web App Link**: https://nodblix.vercel.app/
 - **Youtube Demo Submission**: https://youtu.be/pHStDnz1_rI
 - **Access to Graph**: Please raise a github **issue** here on Github. We'll grant you a READ_ONLY access to our graph database instance.

## Dependencies

Tigergraph: v3.5.0
Flutter: Flutter 2.13.0-0.1.pre • channel beta
Dart: Dart 2.17.0 (build 2.17.0-266.1.beta)

## Installation [Nodblix]

Please give detailed instructions on installing, configuring, and running the project so judges can fully replicate and assess it. 

This can include:
1. Clone repository: `git clone https://github.com/dhruvilp/nodblix-vercel`
2. Install dependencies: Please get started here: https://docs.flutter.dev/get-started/install
3. Access data: https://clinicaltrials.gov/ct2/results 
4. Steps to build/run project: Once Flutter is installed on your machine, run `flutter clean && flutter pub get`. Then, `flutter run -d chrome` to the web version of Nodblix app. Also, you may run the same source code on Android, iOS, macOS, and WindowsOS platforms as wished.

## Getting Started with Flutter

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Known Issues and Future Improvements

We'd love to incorporate more diverse data into our graph so we can explore even more connections and patterns between health conditions and drug compounds. Also, this was our first time using a graph database so we tried our best to both understand the Tigergraph and how to make it work with our project topic.  

## Reflections

Tigergraph challenges has indeed been a great learning experience for both of us. 

## References

Dataset credit: CDC Clinical Trial Results online - https://clinicaltrials.gov/ct2/results
