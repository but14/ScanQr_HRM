import React, { useEffect, useState } from 'react';
// material-ui
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';

// Excel
import * as XLSX from 'xlsx';

// project imports
import MainCard from 'components/MainCard';

export default function DashboardDefault() {
  const [filterStartDate, setFilterStartDate] = useState('');
  const [filterEndDate, setFilterEndDate] = useState('');
  const [data, setData] = useState([]);

  useEffect(() => {
    const user = JSON.parse(localStorage.getItem('user'));
    if (!user?.id) {
      setData([]);
      return;
    }
    fetch(`https://corehr.igroup.com.vn/api/scan/employees-by-manager?manager_id=${user.id}`)
      .then((res) => res.json())
      .then((res) => setData(res.employees || []))
      .catch((err) => {
        setData([]);
        console.error('Lỗi lấy dữ liệu:', err);
      });
  }, []);

  // Hàm để xử lý và lọc dữ liệu theo ngày
  const filteredData = data.filter((row) => {
    const rowDate = new Date(row.created_at);
    const startDate = new Date(filterStartDate);
    const endDate = new Date(filterEndDate);

    const isAfterStart = !filterStartDate || rowDate >= startDate;
    const isBeforeEnd = !filterEndDate || rowDate <= endDate;

    return isAfterStart && isBeforeEnd;
  });

  const handleToExcel = () => {
    const exportData = filteredData.map((row) => ({
      'Họ tên': row.full_name,
      'Số CCCD': row.id_number,
      'Ngày sinh': row.date_of_birth ? row.date_of_birth.slice(0, 10) : '',
      'Địa chỉ': row.place_of_residence,
      'Số điện thoại': row.phone_number || '',
      'Nhà máy': row.factory || '',
      'Thời gian quét': row.created_at ? new Date(row.created_at).toLocaleString() : ''
    }));
    const ws = XLSX.utils.json_to_sheet(exportData);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Danh sách quét mã QR');
    XLSX.writeFile(wb, 'Danh_sach_quet_ma_QR.xlsx');
  };

  return (
    <MainCard
      sx={{ height: '90vh', display: 'flex', flexDirection: 'column' }}
      title={
        <Typography variant="h4" fontWeight="bold">
          Danh sách nhân sự
        </Typography>
      }
    >
      <Stack direction="row" spacing={2} alignItems="center" sx={{ mb: 2 }}>
        <Typography>Từ ngày:</Typography>
        <TextField type="date" size="small" value={filterStartDate} onChange={(e) => setFilterStartDate(e.target.value)} />
        <Typography>Đến ngày:</Typography>
        <TextField type="date" size="small" value={filterEndDate} onChange={(e) => setFilterEndDate(e.target.value)} />
      </Stack>

      <Button variant="contained" color="success" onClick={handleToExcel} sx={{ mb: 2 }}>
        Xuất Excel
      </Button>

      <TableContainer component={Paper} sx={{ flex: 1, minHeight: 0, maxHeight: '100%', overflowY: 'auto' }}>
        <Table stickyHeader>
          <TableHead>
            <TableRow>
              <TableCell>Họ tên</TableCell>
              <TableCell>Số CCCD</TableCell>
              <TableCell>Ngày sinh</TableCell>
              <TableCell>Địa chỉ</TableCell>
              <TableCell>Số điện thoại</TableCell>
              <TableCell>Nhà máy</TableCell>
              <TableCell>Thời gian quét</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {filteredData.map((row) => (
              <TableRow key={row.id}>
                <TableCell>{row.full_name}</TableCell>
                <TableCell>{row.id_number}</TableCell>
                <TableCell>{row.date_of_birth ? new Date(row.date_of_birth).toLocaleDateString('vi-VN') : ''}</TableCell>
                <TableCell>{row.place_of_residence}</TableCell>
                <TableCell>{row.phone}</TableCell>
                <TableCell>{row.factory || 'F17'}</TableCell>
                <TableCell>{row.created_at ? new Date(row.created_at).toLocaleString() : ''}</TableCell>
              </TableRow>
            ))}
            {filteredData.length === 0 && (
              <TableRow>
                <TableCell colSpan={7} align="center">
                  Không có dữ liệu
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </TableContainer>
    </MainCard>
  );
}
