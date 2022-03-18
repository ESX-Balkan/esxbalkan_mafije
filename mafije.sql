/* Realno svi pisu error da nema whitelisted tabela tako da evo i taj kod */
ALTER TABLE jobs add whitelisted BOOLEAN NOT NULL DEFAULT FALSE;

INSERT INTO `addon_account` (name, label, shared) VALUES 
  ('society_zemunski','Zemunski',1),
  ('society_vagos','Vagos',1),
  ('society_peaky','Peaky',1),
  ('society_stikla','Stikla',1),
  ('society_ludisrbi','Ludi Srbi',1),
  ('society_lcn','Lcn',1),
  ('society_lazarevacki','Lazarevacki',1),
  ('society_juzniv','Juzni Vetar',1),
  ('society_gsf','Gsf',1),
  ('society_favela','Favela',1),
  ('society_camorra','Camorra',1),
  ('society_ballas','Ballas',1),
  ('society_automafija','Auto Mafija',1),
  ('society_yakuza','Yakuza',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
  ('society_zemunski','Zemunski',1),
  ('society_vagos','Vagos',1),
  ('society_peaky','Peaky',1),
  ('society_stikla','Stikla',1),
  ('society_ludisrbi','Ludi Srbi',1),
  ('society_lcn','Lcn',1),
  ('society_lazarevacki','Lazarevacki',1),
  ('society_juzniv','Juzni Vetar',1),
  ('society_gsf','Gsf',1),
  ('society_favela','Favela',1),
  ('society_camorra','Camorra',1),
  ('society_ballas','Ballas',1),
  ('society_automafija','Auto Mafija',1),
  ('society_yakuza','Yakuza',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
  ('society_zemunski','Zemunski',1),
  ('society_vagos','Vagos',1),
  ('society_peaky','Peaky',1),
  ('society_stikla','Stikla',1),
  ('society_ludisrbi','Ludi Srbi',1),
  ('society_lcn','Lcn',1),
  ('society_lazarevacki','Lazarevacki',1),
  ('society_juzniv','Juzni Vetar',1),
  ('society_gsf','Gsf',1),
  ('society_favela','Favela',1),
  ('society_camorra','Camorra',1),
  ('society_ballas','Ballas',1),
  ('society_automafija','Auto Mafija',1),
  ('society_yakuza','Yakuza',1)
;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
  ('zemunski', 'Zemunski Klan', 1),
  ('vagos', 'Vagos', 1),
  ('peaky', 'Peaky', 1),
  ('stikla', 'Stikla', 1),
  ('ludisrbi', 'Ludi Srbi', 1),
  ('lcn', 'Lcn', 1),
  ('lazarevacki', 'Lazarevacki Klan', 1),
  ('juzniv', 'Juzni Vetar', 1),
  ('gsf', 'Gsf', 1),
  ('favela', 'Favela', 1),
  ('camorra', 'Camorra', 1),
  ('ballas', 'Ballas', 1),
  ('automafija', 'Auto Mafija', 1),
  ('yakuza', 'Yakuza', 1)
;


INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
  ('zemunski', 0, 'novi', 'Novi', 0, '{}', '{}'),
  ('zemunski', 1, 'radnik', 'Radnik', 0, '{}', '{}'),
  ('zemunski', 2, 'zamenik', 'Zamenik Sefa', 0, '{}', '{}'),
  ('zemunski', 3, 'boss', 'Sef', 0, '{}', '{}'),

  ('vagos', 0, 'novi', 'Novi', 0, '{}', '{}'),
  ('vagos', 1, 'radnik', 'Radnik', 0, '{}', '{}'),
  ('vagos', 2, 'zamenik', 'Zamenik Sefa', 0, '{}', '{}'),
  ('vagos', 3, 'boss', 'Sef', 0, '{}', '{}'),

  ('peaky', 0, 'novi', 'Novi', 0, '{}', '{}'),
  ('peaky', 1, 'radnik', 'Radnik', 0, '{}', '{}'),
  ('peaky', 2, 'zamenik', 'Zamenik Sefa', 0, '{}', '{}'),
  ('peaky', 3, 'boss', 'Sef', 0, '{}', '{}'),

  ('stikla', 0, 'novi', 'Novi', 0, '{}', '{}'),
  ('stikla', 1, 'radnik', 'Radnik', 0, '{}', '{}'),
  ('stikla', 2, 'zamenik', 'Zamenik Sefa', 0, '{}', '{}'),
  ('stikla', 3, 'boss', 'Sef', 0, '{}', '{}'),

  ('ludisrbi', 0, 'novi', 'Novi', 0, '{}', '{}'),
  ('ludisrbi', 1, 'radnik', 'Radnik', 0, '{}', '{}'),
  ('ludisrbi', 2, 'zamenik', 'Zamenik Sefa', 0, '{}', '{}'),
  ('ludisrbi', 3, 'boss', 'Sef', 0, '{}', '{}'),

  ('lcn', 0, 'novi', 'Novi', 0, '{}', '{}'),
  ('lcn', 1, 'radnik', 'Radnik', 0, '{}', '{}'),
  ('lcn', 2, 'zamenik', 'Zamenik Sefa', 0, '{}', '{}'),
  ('lcn', 3, 'boss', 'Sef', 0, '{}', '{}'),

  ('lazarevacki', 0, 'novi', 'Novi', 0, '{}', '{}'),
  ('lazarevacki', 1, 'radnik', 'Radnik', 0, '{}', '{}'),
  ('lazarevacki', 2, 'zamenik', 'Zamenik Sefa', 0, '{}', '{}'),
  ('lazarevacki', 3, 'boss', 'Sef', 0, '{}', '{}'),

  ('juzniv', 0, 'novi', 'Novi', 0, '{}', '{}'),
  ('juzniv', 1, 'radnik', 'Radnik', 0, '{}', '{}'),
  ('juzniv', 2, 'zamenik', 'Zamenik Sefa', 0, '{}', '{}'),
  ('juzniv', 3, 'boss', 'Sef', 0, '{}', '{}'),

  ('gsf', 0, 'novi', 'Novi', 0, '{}', '{}'),
  ('gsf', 1, 'radnik', 'Radnik', 0, '{}', '{}'),
  ('gsf', 2, 'zamenik', 'Zamenik Sefa', 0, '{}', '{}'),
  ('gsf', 3, 'boss', 'Sef', 0, '{}', '{}'),

  ('favela', 0, 'novi', 'Novi', 0, '{}', '{}'),
  ('favela', 1, 'radnik', 'Radnik', 0, '{}', '{}'),
  ('favela', 2, 'zamenik', 'Zamenik Sefa', 0, '{}', '{}'),
  ('favela', 3, 'boss', 'Sef', 0, '{}', '{}'),

  ('camorra', 0, 'novi', 'Novi', 0, '{}', '{}'),
  ('camorra', 1, 'radnik', 'Radnik', 0, '{}', '{}'),
  ('camorra', 2, 'zamenik', 'Zamenik Sefa', 0, '{}', '{}'),
  ('camorra', 3, 'boss', 'Sef', 0, '{}', '{}'),

  ('ballas', 0, 'novi', 'Novi', 0, '{}', '{}'),
  ('ballas', 1, 'radnik', 'Radnik', 0, '{}', '{}'),
  ('ballas', 2, 'zamenik', 'Zamenik Sefa', 0, '{}', '{}'),
  ('ballas', 3, 'boss', 'Sef', 0, '{}', '{}'),

  ('automafija', 0, 'novi', 'Novi', 0, '{}', '{}'),
  ('automafija', 1, 'radnik', 'Radnik', 0, '{}', '{}'),
  ('automafija', 2, 'zamenik', 'Zamenik Sefa', 0, '{}', '{}'),
  ('automafija', 3, 'boss', 'Sef', 0, '{}', '{}'),

  ('yakuza', 0, 'novi', 'Novi', 0, '{}', '{}'),
  ('yakuza', 1, 'radnik', 'Radnik', 0, '{}', '{}'),
  ('yakuza', 2, 'zamenik', 'Zamenik Sefa', 0, '{}', '{}'),
  ('yakuza', 3, 'boss', 'Sef', 0, '{}', '{}');

